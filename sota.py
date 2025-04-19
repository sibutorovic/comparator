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



def clean_title_for_embedding(title):
    print('in', title)
    title = title.lower()

    # Remove irrelevant terms
    patterns_to_remove = [
        r'\b\d+ ?(lb|lbs|kg|g|gramos|gr)\b',  # weights like 5 lb, 2kg
        r'\b(original|nuevo|new|muestra|sample|version|edicion)\b',  # common irrelevant words
        r'\b(x\d+|pack|paquete|unidad|unit)\b',  # pack size
        r'\b(oferta|promo|promocion|descuento|rebaja|gratis|envio)\b',  # promo terms
        r'\b\d{1,2} ?caps\b',  # like 90 caps
        r'\b\d{1,4} ?ml\b',  # like 500 ml
        r'[()]',  # remove parens
    ]
    
    for pattern in patterns_to_remove:
        title = re.sub(pattern, '', title)

    # Remove extra spaces
    title = re.sub(r'\s+', ' ', title).strip()
    print('out', title)
    return title

def get_titles():
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
        host=DB_HOST, port=DB_PORT
    )
    cur = conn.cursor()
    cur.execute("SELECT scrap_id, data, source FROM scrap_data")
    products = cur.fetchall()
    cur.close()
    conn.close()
    return products

def cluster_titles(titles, ids, threshold=0.95):

    input_texts = [f"query: {clean_title_for_embedding(t)}" for t in titles]

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
    for cluster_id in set(clusters):
        clustered[cluster_id] = []

    for idx, cluster_id in enumerate(clusters):
        clustered[cluster_id].append((ids[idx], titles[idx], sources[idx]))

    return clustered

def print_clusters(clustered):
    for cluster_id, items in clustered.items():
        print(f"\n🧩 Cluster {cluster_id} ({len(items)} items):")
        for item in items:
            print(f"  - {item[0]} -  {item[1]}")

def export_to_csv(clustered, filename="clusters.csv"):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(["cluster_id", "source","scrap_id", "title"])
        for cluster_id, items in clustered.items():
            for scrap_id, title, source in items:
                writer.writerow([ cluster_id, source, scrap_id, title])
    print(f"\n✅ Clusters exported to {filename}")

if __name__ == "__main__":
    products = get_titles()
    ids = [str(p[0]) for p in products]
    titles = [p[1] for p in products]
    sources = [p[   2] for p in products]
    clustered = cluster_titles(titles, ids, threshold=0.99)
    print_clusters(clustered)
    export_to_csv(clustered)
