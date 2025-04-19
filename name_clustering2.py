import csv
import psycopg2
import re
from sentence_transformers import SentenceTransformer
import numpy as np

# --- DB Config ---
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'admin'
DB_HOST = 'localhost'
DB_PORT = '5432'

model = SentenceTransformer("intfloat/multilingual-e5-large")

brand_synonyms = {
    "dymatize": ["dym", "dymatize nutrition", "dymatize labs", "dymatize nutritionals"],
    "iso100": ["iso 100", "iso100", "dymatize iso"],
    "optimum nutrition": ["optimum nutrition", "on", "optimum"],
}

STOPWORDS = {"whey", "protein", "powder"}  # optional


def load_encoded_brand_representatives(model, brand_synonyms):
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
        brand_lookup[canon] = brand
        for synonym in brand_synonyms.get(brand, []):
            synonym_clean = synonym.strip().lower()
            all_names.append(synonym_clean)
            brand_lookup[synonym_clean] = brand

    all_names_cleaned = [f"query: {name}" for name in all_names]
    embeddings = model.encode(all_names_cleaned, normalize_embeddings=True)

    return all_names, embeddings, brand_lookup


def match_brand_by_embedding(title, all_brand_names, brand_embeddings, brand_lookup, model, threshold=0.7):
    cleaned_title = f"query: {title.lower().strip()}"
    title_embedding = model.encode([cleaned_title], normalize_embeddings=True)[0]
    similarities = np.dot(brand_embeddings, title_embedding)
    best_idx = np.argmax(similarities)
    best_score = similarities[best_idx]
    matched_string = all_brand_names[best_idx].lower()
    if best_score >= threshold:
        return brand_lookup.get(matched_string, "UNKNOWN")
    return "UNKNOWN"


def get_raw_titles():
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
        host=DB_HOST, port=DB_PORT
    )
    cur = conn.cursor()
    cur.execute("SELECT id, raw_title FROM data")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows


def clean_title(title, brand, brand_synonyms, stopwords=STOPWORDS):
    title = title.lower()

    all_brand_tokens = set()
    all_brand_tokens.add(brand.lower())
    all_brand_tokens.update([s.lower() for s in brand_synonyms.get(brand, [])])

    for token in sorted(all_brand_tokens, key=lambda x: -len(x)):
        token_escaped = re.escape(token)
        title = re.sub(rf'\b{token_escaped}\b', '', title)

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


def export_for_labeling():
    all_brand_names, brand_embeddings, brand_lookup = load_encoded_brand_representatives(model, brand_synonyms)
    products = get_raw_titles()

    with open("products_for_labeling.csv", mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(["id", "original_title", "matched_brand", "cleaned_title", "manual_label"])

        for pid, raw_title in products:
            matched_brand = match_brand_by_embedding(raw_title, all_brand_names, brand_embeddings, brand_lookup, model)
            cleaned = clean_title(raw_title, matched_brand, brand_synonyms) if matched_brand != "UNKNOWN" else raw_title
            writer.writerow([pid, raw_title, matched_brand, cleaned, ""])


if __name__ == "__main__":
    export_for_labeling()
    print("✅ Exported to products_for_labeling.csv")
