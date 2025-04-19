from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import time
import psycopg2
import re

# --- PostgreSQL Config ---
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'admin'
DB_HOST = 'localhost'
DB_PORT = '5432'

SOURCE_ID = 4  # Unique ID for ChileSuplementos

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
    patterns = [
        r'\b\d+\.?\d*\s?(gr|g|gramos|kg|ml|cc|lbs|lb|oz)\b',
        r'\(\d+\.?\d*\s?(gr|g|gramos|kg|ml|cc|lbs|lb|oz)\)'
    ]

    all_matches = []
    for pattern in patterns:
        matches = re.findall(pattern, title, flags=re.IGNORECASE)
        all_matches.extend(re.findall(r'\d+\.?\d*\s?(?:gr|g|gramos|kg|ml|cc|lbs|lb|oz)', title, flags=re.IGNORECASE))

    if not all_matches:
        return None

    # Return the longest match (e.g. "5.1 lbs" instead of "1 lbs")
    return max(all_matches, key=len).lower().strip("() ")


def extract_product_name(title, quantity):
    if quantity:
        title = re.sub(re.escape(quantity), '', title, flags=re.IGNORECASE)
    return clean_title(title)


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


# --- Scraper Setup ---
options = Options()
# options.add_argument("--headless")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

chromedriver_path = r'C:\Users\Seba\Downloads\chromedriver-win64\chromedriver.exe'
service = Service(chromedriver_path)
driver = webdriver.Chrome(service=service, options=options)

base_url = "https://www.chilesuplementos.cl/categoria/productos/tipo-de-proteina/whey-protein/page/{}"
page = 1

while True:
    print(f"\nScraping page {page}...")
    url = base_url.format(page)
    driver.get(url)
    time.sleep(3)

    soup = BeautifulSoup(driver.page_source, "html.parser")

    container = soup.select_one("div.posts-wrap.products-container.products")
    if not container:
        print("No container found. Stopping.")
        break

    product_blocks = container.select("div.porto-tb-item.product")
    if not product_blocks:
        print("No more products found. Stopping.")
        break

    for product in product_blocks:
        try:
            name_tag = product.select_one("h3.porto-heading a")
            brand_tag = product.select_one("span.porto-tb-meta a")
            price_tag = product.select_one(".tb-woo-price .amount")
            image_tag = product.select_one("img.attachment-woocommerce_thumbnail")

            title = name_tag.text.strip() if name_tag else "No title"
            price = price_tag.text.strip() if price_tag else "No price"
            brand = brand_tag.text.strip() if brand_tag else ""
            url = name_tag["href"] if name_tag else ""
            image = image_tag["src"] if image_tag else ""

            raw_title = clean_title(f"{brand} {title}")
            quantity = extract_quantity(raw_title)
            product_name = extract_product_name(raw_title, quantity)

            price_number = (
                float(price.replace('.', '').replace(',', '.').replace('$', ''))
                if price else None
            )

            print(f"- {product_name} | ${price_number} | qty: {quantity}")

            insert_to_data_table(SOURCE_ID, brand.lower(), product_name, quantity, raw_title, price_number)


        except Exception as e:
            print(f"\u26a0\ufe0f Error parsing product: {e}")

    next_button = soup.select_one("a.next.page-numbers")
    if not next_button:
        print("No more pages. Done.")
        break

    page += 1

driver.quit()