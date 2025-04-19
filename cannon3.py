import requests
from bs4 import BeautifulSoup
import psycopg2
import time
import uuid
import re

# --- PostgreSQL Config ---
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'admin'
DB_HOST = 'localhost'
DB_PORT = '5432'

SOURCE_ID = 3  # unique source ID for OneNutrition

def get_db_connection():
    return psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
        host=DB_HOST, port=DB_PORT
    )

def clean_title(title):
    title = title.lower()
    title = re.sub(r'[^\w\s./%]', '', title)
    title = re.sub(r'\s+', ' ', title)
    return title.strip()

def extract_quantity(title):
    """Match quantities like '5lb', '300gr', '10kg', '2.5kg', etc."""
    match = re.search(r'(\d+(\.\d+)?\s?(lb|kg|gr|g|servings|caps))', title)
    return match.group(0) if match else None

def clean_price(price):
    """Remove non-numeric characters from the price and convert to a float."""
    price_cleaned = re.sub(r'[^\d.,]', '', price)
    price_cleaned = price_cleaned.replace(',', '.')  # In case there's a comma as a decimal separator
    try:
        return float(price_cleaned)
    except ValueError:
        return None

def insert_to_db(brand, product_name, quantity, raw_title, price):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO data (source, brand, product_name, quantity, raw_title, price)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            SOURCE_ID,
            brand,
            product_name,
            quantity,
            raw_title,
            price
        ))
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"❌ DB Insert Error: {e}")

def extract_product_name(prod, quantity):

    
    """Extract product name while removing quantity (like '5lb')."""
    title_tag = prod.find("span", class_="product-title")
    
    if title_tag:
        title = title_tag.text.strip().lower()
    else:
        # If no title is found, look for other possible tags or attributes
        title_tag = prod.find("h1") or prod.find("h2")
        if title_tag:
            title = title_tag.text.strip().lower()
        else:
            title = "No title"

    # If quantity is identified, remove it from the title

    title = clean_title(title)
    print(title, quantity)
    if quantity:
        title = re.sub(r'\b' + re.escape(quantity) + r'\b', '', title).strip()

    # Clean the extracted title
    return clean_title(title)

def scrape_onenutrition():
    url = "https://onenutrition.cl/tienda/whey-protein"
    response = requests.get(url)
    if response.status_code != 200:
        print(f"Failed to load page, status code {response.status_code}")
        return

    soup = BeautifulSoup(response.text, "html.parser")
    products = soup.find_all("article", class_="product-miniature")

    for prod in products:
        try:
            # Extract quantity first
            title = extract_product_name(prod, quantity=None)  # Extract the name without quantity first
            quantity = extract_quantity(title)  # Extract the quantity from the title

            # Clean the title again after removing the quantity
            product_name = extract_product_name(prod, quantity)

            price_tag = prod.find("span", class_="price")
            old_price_tag = prod.find("span", class_="regular-price")
            img_tag = prod.find("img", class_="ttproduct-img1")
            link_tag = prod.find("a", class_="thumbnail")

            price = price_tag.text.strip().replace("\xa0", " ") if price_tag else "No price"
            old_price = old_price_tag.text.strip().replace("\xa0", " ") if old_price_tag else ""
            img_url = img_tag["src"] if img_tag else ""
            prod_url = link_tag["href"] if link_tag else ""

            # Clean the price and convert it to a numeric value
            price_cleaned = clean_price(price)

            canonical_name = f" {product_name}".strip()
            print(f"- {canonical_name} | {price_cleaned} | Quantity: {quantity}")

            # Insert to DB
            insert_to_db("", product_name, quantity, title, price_cleaned)

        except Exception as e:
            print(f"⚠️ Error parsing product: {e}")


if __name__ == "__main__":
    scrape_onenutrition()
