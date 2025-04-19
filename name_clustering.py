from sentence_transformers import SentenceTransformer
from sklearn.cluster import AgglomerativeClustering
import psycopg2
import numpy as np
import csv
import re

# --- DB Config ---
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'admin'
DB_HOST = 'localhost'
DB_PORT = '5432'

# Load the multilingual E5 model
model = SentenceTransformer("intfloat/multilingual-e5-large")


brand_synonyms = {
    "dymatize": ["dym", "dymatize nutrition", "dymatize labs", "dymatize nutritionals"],
    "iso100": ["iso 100", "iso100", "dymatize iso"],
    "optimum nutrition": ["optimum nutrition", "on", "optimum"],
    # Add more brands and their synonyms here...
}

STOPWORDS = {"whey", "protein", "powder"}  # Add more words to ignore



def build_brand_lookup(brand_reps, brand_synonyms):
    lookup = {}
    for brand in brand_reps:
        lookup[brand.lower()] = brand  # canonical form
        for synonym in brand_synonyms.get(brand, []):
            lookup[synonym.lower()] = brand  # map synonyms back to canonical
    return lookup


def load_encoded_brand_representatives(model, brand_synonyms):
    # Get canonical reps from DB
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
        host=DB_HOST, port=DB_PORT
    )
    cur = conn.cursor()
    cur.execute("SELECT representative FROM brand_representatives")
    brand_reps = [r[0] for r in cur.fetchall()]
    cur.close()
    conn.close()

    all_names = []
    brand_lookup = {}

    for brand in brand_reps:
        canon = brand.strip().lower()
        all_names.append(canon)
        brand_lookup[canon] = brand  # map canonical to itself

        for synonym in brand_synonyms.get(brand, []):
            synonym_clean = synonym.strip().lower()
            all_names.append(synonym_clean)
            brand_lookup[synonym_clean] = brand  # map synonym -> canonical

    print(all_names)
    all_names_cleaned = [f"query: {name}" for name in all_names]
    embeddings = model.encode(all_names_cleaned, normalize_embeddings=True)

    return all_names, embeddings, brand_lookup, brand_reps



def match_brand_by_embedding(title, all_brand_names, brand_embeddings, brand_lookup, model, threshold=0.7):
    cleaned_title = f"query: {title.lower().strip()}"
    title_embedding = model.encode([cleaned_title], normalize_embeddings=True)[0]

    similarities = np.dot(brand_embeddings, title_embedding)
    best_idx = np.argmax(similarities)
    best_score = similarities[best_idx]

    matched_string = all_brand_names[best_idx].lower()
    #print(title)
    #print('best match:', matched_string, ' with score ', best_score, ', index', best_idx)
    if best_score >= threshold:
        return brand_lookup.get(matched_string, "UNKNOWN")
    return "UNKNOWN"


def get_raw_titles():
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
        host=DB_HOST, port=DB_PORT
    )
    cur = conn.cursor()
    cur.execute("SELECT id, raw_title, source FROM data")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows

def clean_title(title, brand_reps, stopwords=STOPWORDS):
    title = title.lower()

    # Build a full list of brand tokens: canonical + synonyms
    all_brand_tokens = set()
    for brand in brand_reps:
        all_brand_tokens.add(brand.lower())
        if brand in brand_synonyms:
            all_brand_tokens.update([s.lower() for s in brand_synonyms[brand]])

    # Remove all brand tokens
    for token in sorted(all_brand_tokens, key=lambda x: -len(x)):  # longest first to avoid partial matches
        token_escaped = re.escape(token)
        title = re.sub(rf'\b{token_escaped}\b', '', title)

    # Remove stopwords (common words like 'whey', 'protein', etc.)
    #title = ' '.join([word for word in title.split() if word not in stopwords])

    # Remove weight/volume/unit info
    patterns_to_remove = [
        r'\b\d+(?:\.\d+)? ?(lbs|lb|kg|gr|gramos|g)\b',
        r'\b\d{1,4} ?(ml|caps|tablet[as]?|softgels?)\b',
        r'\b(x\d+|pack|paquete|unidad|unit)\b',
        r'\b(original|nuevo|new|muestra|sample|version|edicion)\b',
        r'\b(oferta|promo|promocion|descuento|rebaja|gratis|envio)\b',
        r'[()]',
    ]
    for pattern in patterns_to_remove:
        title = re.sub(pattern, '', title)

    title = re.sub(r'\s+', ' ', title).strip()
    return title



def cluster_names(names, ids, sources, brands, brand_reps, threshold=0.97):
    input_texts = [
        f"query: {clean_title(title, [brand])}" for title, brand in zip(names, brands)
    ]
    embeddings = model.encode(input_texts, normalize_embeddings=True)

    clustering_model = AgglomerativeClustering(
        n_clusters=None,
        distance_threshold=1 - threshold,
        metric='cosine',
        linkage='average'
    )
    clustering_model.fit(embeddings)
    clusters = clustering_model.labels_

    clustered = {}
    representatives = {}

    for cluster_id in set(clusters):
        clustered[cluster_id] = []

    for idx, cluster_id in enumerate(clusters):
        clustered[cluster_id].append({
            "id": ids[idx],
            "source": sources[idx],
            "brand": brands[idx],
            "name": clean_title(names[idx], [brands[idx]]),
            "original_name": names[idx],
            "embedding": embeddings[idx]
        })

    for cluster_id, items in clustered.items():
        vectors = np.stack([item["embedding"] for item in items])
        centroid = np.mean(vectors, axis=0)
        similarities = np.dot(vectors, centroid)
        best_idx = np.argmax(similarities)
        representatives[cluster_id] = items[best_idx]

    return clustered, representatives

def print_clusters(clustered):
    for cluster_id, items in clustered.items():
        print(f"\n\U0001F9E9 Cluster {cluster_id} ({len(items)} items):")
        for item in items:
            print(f"  - {item['id']} - {item['name']} (orig: {item['original_name']}) - {item['brand']} ({item['source']})")


def export_to_csv(clustered, filename="name_clusters.csv"):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(["cluster_id", "source", "scrap_id", "name"])
        for cluster_id, items in clustered.items():
            for item in items:
                writer.writerow([cluster_id, item['source'], item['id'], item['name']])
    print(f"\n✅ Name clusters exported to {filename}")

from collections import defaultdict

if __name__ == "__main__":
    all_brand_names, brand_embeddings, brand_lookup, canonical_brand_reps = load_encoded_brand_representatives(model, brand_synonyms)
    raw_products = get_raw_titles()

    ids = []
    titles = []
    sources = []
    matched_brands = []

    for pid, raw_title, src in raw_products:
        matched_brand = match_brand_by_embedding(raw_title, all_brand_names, brand_embeddings, brand_lookup, model)
        ids.append(str(pid))
        titles.append(raw_title)
        sources.append(src)
        matched_brands.append(matched_brand)
        #print(f"title: {raw_title} matched to brand {matched_brand}" )

    # Group items by brand
    brand_groups = defaultdict(lambda: {"ids": [], "titles": [], "sources": [], "brands": []})
    for i in range(len(titles)):
        brand = matched_brands[i]
        if brand != "UNKNOWN":
            brand_groups[brand]["ids"].append(ids[i])
            brand_groups[brand]["titles"].append(titles[i])
            brand_groups[brand]["sources"].append(sources[i])
            brand_groups[brand]["brands"].append(brand)

    all_clustered = {}
    all_representatives = {}

    for brand, group in brand_groups.items():
        print(f"\n🔷 Clustering products for brand: {brand} ({len(group['titles'])} items)")

        if len(group["titles"]) < 2:
            print(f"⏭️ Skipping brand '{brand}' — not enough items to cluster.")
            continue

        clustered, representatives = cluster_names(
            group["titles"],
            group["ids"],
            group["sources"],
            group["brands"],
            [brand],  # only the relevant brand
            threshold=0.90
        )
        all_clustered[brand] = clustered
        all_representatives[brand] = representatives
        print_clusters(clustered)


    print("\n🌟 Representative Product Names per Cluster (by brand):")
    for brand, reps in all_representatives.items():
        for cluster_id, rep in reps.items():
            print(f"[{brand}] Cluster {cluster_id}: {rep['name']} (ID: {rep['id']}, Source: {rep['source']})")

    # Optional CSV export per brand:
    for brand, clustered in all_clustered.items():
        #export_to_csv(clustered, filename=f"name_clusters_{brand.replace(' ', '_')}.csv")
