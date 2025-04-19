from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

# List of canonical product names
canonical_names = [
    "Gold Standard 100% Whey Protein 5lb",
    "Gold Standard 100% Whey Protein 2lb",
    "Prostar Whey",
    "Whey pro Win",
    "Nitro Tech 100% Whey Gold",
]

# Initialize SBERT model
model = SentenceTransformer('paraphrase-MiniLM-L6-v2')

def match_to_canonical_nlp(product_title, canonical_names):
    # Embed the product title and the canonical names
    title_embedding = model.encode([product_title])
    canonical_embeddings = model.encode(canonical_names)

    # Calculate cosine similarity
    similarities = cosine_similarity(title_embedding, canonical_embeddings)

    # Find the index of the most similar canonical name
    best_match_index = similarities.argmax()
    return canonical_names[best_match_index], similarities[0][best_match_index]

# Test the function with a scraped product title
product_title = "Gold Standard 100% Whey Protein (1.85 Lb) - Original"
best_match, similarity_score = match_to_canonical_nlp(product_title, canonical_names)

print(f"Best match: {best_match} with similarity score: {similarity_score}")
