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

def clean_brand(brand):
    if not brand:
        return ""
    brand = brand.lower().strip()
    brand = re.sub(r'\s+', ' ', brand)
    return brand

def get_brands():
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
        host=DB_HOST, port=DB_PORT
    )
    cur = conn.cursor()
    cur.execute("SELECT id, brand, source FROM data")
    data = cur.fetchall()
    cur.close()
    conn.close()
    return data

def cluster_brands(brands, ids, sources, threshold=0.95):
    input_texts = [f"query: {clean_brand(b)}" for b in brands]
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
            "brand": brands[idx],
            "source": sources[idx],
            "embedding": embeddings[idx]
        })

    for cluster_id, items in clustered.items():
        # Stack embeddings into matrix
        vectors = np.stack([item["embedding"] for item in items])
        centroid = np.mean(vectors, axis=0)
        similarities = np.dot(vectors, centroid)
        best_idx = np.argmax(similarities)
        representatives[cluster_id] = items[best_idx]

    return clustered, representatives


def print_clusters(clustered):
    for cluster_id, items in clustered.items():
        print(f"\n🧩 Cluster {cluster_id} ({len(items)} items):")
        for item in items:
           print(f"  - {item['id']} - {item['brand']} ({item['source']})")

def export_to_csv(clustered, filename="brand_clusters.csv"):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(["cluster_id", "source", "scrap_id", "brand"])
        for cluster_id, items in clustered.items():
            for scrap_id, brand, source in items:
                writer.writerow([cluster_id, source, scrap_id, brand])
    print(f"\n✅ Brand clusters exported to {filename}")

def store_clusters_and_reps(clustered, representatives):
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
        host=DB_HOST, port=DB_PORT
    )
    cur = conn.cursor()

    # Create brand_clusters table
    cur.execute("""
        CREATE TABLE IF NOT EXISTS brand_clusters (
            id SERIAL PRIMARY KEY,
            scrap_id TEXT,
            source TEXT,
            brand TEXT,
            cluster_id INT
        )
    """)

    # Create brand_representatives table
    cur.execute("""
        CREATE TABLE IF NOT EXISTS brand_representatives (
            cluster_id INT PRIMARY KEY,
            representative TEXT
        )
    """)

    # Clear existing entries
    cur.execute("DELETE FROM brand_clusters")
    cur.execute("DELETE FROM brand_representatives")

    # Insert all clustered brand data
    for cluster_id, items in clustered.items():
        for item in items:
           cur.execute("""
                INSERT INTO brand_clusters (scrap_id, source, brand, cluster_id)
                VALUES (%s, %s, %s, %s)
            """, (item['id'], item['source'], item['brand'], int(cluster_id)))


    # Insert representatives
    for cluster_id, rep in representatives.items():
        cur.execute("""
            INSERT INTO brand_representatives (cluster_id, representative)
            VALUES (%s, %s)
        """, (int(cluster_id), rep['brand']))


    conn.commit()
    cur.close()
    conn.close()
    print("\n📥 Clusters and representatives stored in database.")


if __name__ == "__main__":
    data = get_brands()
    ids = [str(p[0]) for p in data]
    brands = [p[1] if p[1] else '' for p in data]
    sources = [p[2] for p in data]
    clustered, representatives = cluster_brands(brands, ids, sources, threshold=0.95)

    print_clusters(clustered)

    # Print representative brands
    print("\n🌟 Representative Brands per Cluster:")
    for cluster_id, rep in representatives.items():
        print(f"Cluster {cluster_id}: {rep['brand']} (ID: {rep['id']}, Source: {rep['source']})")

    #export_to_csv(clustered)
    store_clusters_and_reps(clustered, representatives)


