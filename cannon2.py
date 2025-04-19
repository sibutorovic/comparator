import requests
from bs4 import BeautifulSoup
import psycopg2
import time
import re

# --- PostgreSQL Config ---
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'admin'
DB_HOST = 'localhost'
DB_PORT = '5432'

SOURCE_ID = 2  # Unique source ID for SupleStore

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
    match = re.search(r'(\d+(\.\d+)?\s?(lb|kg|gr|g|servings|caps))', title)
    return match.group(0) if match else None


def extract_product_name(title, brand, quantity):
    temp = title
    if brand:
        temp = temp.replace(brand.lower(), "")
    if quantity:
        temp = temp.replace(quantity, "")
    return temp.strip()

def insert_to_data_table(source, brand, product_name, quantity, raw_title, price):
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("""
            INSERT INTO data (source, brand, product_name, quantity, raw_title, price)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            source,
            brand,
            product_name,
            quantity,
            raw_title,
            price
        ))

        conn.commit()
        cur.close()
        conn.close()
        print(f"✅ Inserted: {raw_title}")

    except Exception as e:
        print(f"❌ DB Insert Error: {e}")

def scrape_suplestore():
    base_url = "https://www.suplestore.cl/collection/whey-blend"
    page = 1

    while True:
        url = f"{base_url}?page={page}"
        print(f"Scraping page {page}: {url}")
        response = requests.get(url)
        if response.status_code != 200:
            print(f"Failed to load page {page}, status code {response.status_code}")
            break

        soup = BeautifulSoup(response.text, "html.parser")
        products = soup.find_all("div", class_="bs-product")

        if not products:
            print("No more products found.")
            break

        for prod in products:
            try:
                title_tag = prod.find("h6", class_="texto")
                brand_tag = prod.find("small", class_="badge-secondary")
                final_price_tag = prod.find("div", class_="bs-product-final-price")

                title = title_tag.text.strip() if title_tag else "No title"
                brand = brand_tag.text.strip().lower() if brand_tag else ""
                raw_title = clean_title(f"{brand} {title}")
                quantity = extract_quantity(raw_title)
                product_name = extract_product_name(raw_title, brand, quantity)

                price_text = final_price_tag.text.strip() if final_price_tag else None
                price = (
                    float(price_text.replace('.', '').replace(',', '.').replace('$', ''))
                    if price_text else None
                )

                insert_to_data_table(SOURCE_ID, brand, product_name, quantity, raw_title, price)

            except Exception as e:
                print(f"⚠️ Error parsing product: {e}")

        page += 1
        time.sleep(1)

if __name__ == "__main__":
    scrape_suplestore()
