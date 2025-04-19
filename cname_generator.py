from sentence_transformers import SentenceTransformer
import psycopg2
import numpy as np
from sklearn.cluster import DBSCAN
from sklearn.preprocessing import normalize

# --- DB Config ---
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'admin'
DB_HOST = 'localhost'
DB_PORT = '5432'

# Load multilingual SBERT model
model = SentenceTransformer("sentence-transformers/LaBSE")
# model = SentenceTransformer("paraphrase-multilingual-mpnet-base-v2")

def get_titles():
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
        host=DB_HOST, port=DB_PORT
    )
    cur = conn.cursor()
    cur.execute("SELECT scrap_id, data FROM scrap_data")
    products = cur.fetchall()
    cur.close()
    conn.close()
    return products

def cluster_titles(titles, ids, eps=0.15, min_samples=2):
    embeddings = model.encode(titles, convert_to_numpy=True, show_progress_bar=True)
    
    # Normalize for cosine similarity
    embeddings = normalize(embeddings)

    # Cosine distance = 1 - cosine similarity → use 'euclidean' after normalization
    clustering_model = DBSCAN(
        eps=eps,
        min_samples=min_samples,
        metric='euclidean'
    )

    labels = clustering_model.fit_predict(embeddings)

    clustered = {}
    for cluster_id in set(labels):
        clustered[cluster_id] = []

    for idx, cluster_id in enumerate(labels):
        clustered[cluster_id].append((ids[idx], titles[idx]))

    return clustered

def print_clusters(clustered):
    for cluster_id, items in clustered.items():
        cluster_label = f"🧩 Cluster {cluster_id}" if cluster_id != -1 else "❌ Noise"
        print(f"\n{cluster_label} ({len(items)} items):")
        for item in items:
            print(f"  - {item[0]} - {item[1]}")

if __name__ == "__main__":
    products = get_titles()
    ids = [str(p[0]) for p in products]
    titles = [p[1] for p in products]
    clustered = cluster_titles(titles, ids, eps=0.5, min_samples=1)
    print_clusters(clustered)
