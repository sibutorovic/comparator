import re
import uuid
import requests
from bs4 import BeautifulSoup, NavigableString
import psycopg2
import json
# --- PostgreSQL Config ---
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'admin'
DB_HOST = 'localhost'
DB_PORT = '5432'

SOURCE_ID = 1  # Identifier for "allnutrition.cl"

def extract_quantity(title):
    match = re.search(r'(\d+(\.\d+)?\s?(lb|kg|g|servings|caps))', title)
    return match.group(0) if match else None

def extract_product_name(title, brand, quantity):
    temp = title
    if brand:
        temp = temp.replace(brand.lower(), "")
    if quantity:
        temp = temp.replace(quantity, "")
    return temp.strip()


def clean_title(title):
    title = title.lower()
    title = re.sub(r'[^\w\s./%]', '', title)
    title = re.sub(r'\s+', ' ', title)
    return title.strip()

def extract_price(price_tag):
    if not price_tag:
        return None
    for content in price_tag.contents:
        if isinstance(content, NavigableString):
            return content.strip()
    return None

def scrape_all_pages(base_url):
    page = 1
    scraped_data = []

    while True:
        paginated_url = f"{base_url}&page={page}"
        print(f"🔍 Scraping page {page}: {paginated_url}")

        try:
            response = requests.get(paginated_url)
            response.raise_for_status()
            soup = BeautifulSoup(response.text, 'html.parser')

            products = soup.find_all('div', class_='c-card-product')
            if not products:
                print("✅ No more products found. Stopping.")
                break

            for product_tag in products:
                title_tag = product_tag.find('h6', class_='c-card-product__title')
                brand_tag = product_tag.find('div', class_='c-card-product__vendor')
                price_tag = product_tag.find('div', class_='c-card-product__price')

                if title_tag:
                    raw_title = title_tag.get_text(strip=True)
                    brand = brand_tag.get_text(strip=True).lower() if brand_tag else ''
                    cleaned_title = clean_title(f"{brand} {raw_title}")
                    
                    quantity = extract_quantity(cleaned_title)
                    product_name = extract_product_name(cleaned_title, brand, quantity)
                    price = extract_price(price_tag)


                    #print(brand, product_name, quantity, cleaned_title, price)

                    scraped_data.append({
                        'scrap_id': 1,
                        'source': SOURCE_ID,
                        'brand': brand,
                        'product_name': product_name,
                        'quantity': quantity,
                        'full_title': cleaned_title,
                        'price': price
                    })

            page += 1

        except requests.exceptions.RequestException as e:
            print(f"❌ Error fetching page {page}: {e}")
            break

    return scraped_data

def insert_to_scrap_data_table(data_list):
    try:
        conn = psycopg2.connect(
            dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD,
            host=DB_HOST, port=DB_PORT
        )
        cursor = conn.cursor()

        for row in data_list:
            cursor.execute("""
                INSERT INTO data (source, brand, product_name, quantity, raw_title, price)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (
                row['source'],
                row['brand'],
                row['product_name'],
                row['quantity'],
                row['full_title'],
                float(row['price'].replace('.', '').replace(',', '.').replace('$', '')) if row['price'] else None
            ))
            print(f"✅ Inserted: {row['full_title']}")

        conn.commit()
        cursor.close()
        conn.close()
        print("✅ All done and committed to database.")

    except Exception as e:
        print(f"❌ Database error: {e}")
        print(f"❌ Database error: {e}")

# Run everything
if __name__ == "__main__":
    data = scrape_all_pages('https://allnutrition.cl/collections/whey-protein?&sort_by=manual')
    print(json.dumps(data, indent=2))
    insert_to_scrap_data_table(data)
