import spacy
import re
import requests
from bs4 import BeautifulSoup

# Load the pre-trained spaCy model
nlp = spacy.load("es_core_news_sm")

# Sample product title text (for testing)
product_title = "Optimum Nutrition Whey Protein 500g - Vanilla $45.99"

def extract_quantity_spacy(title):
    """Extract quantity as a number and unit using spaCy and regex."""
    
    title = title.lower()  # Convert to lowercase
    doc = nlp(title)
    
    # Try extracting a quantity using regex
    match = re.search(r'(\d+(\.\d+)?(g|kg|ml|mg|l|oz|lbs))', title)
    if match:
        value = match.group(1)
        unit = match.group(3)
        normalized_value, normalized_unit = normalize_quantity(value, unit)
        return normalized_value, normalized_unit

    # If regex doesn't match, use spaCy's dependency parsing
    for token in doc:
        if token.like_num:  # If token looks like a number
            # Check for a quantity unit (g, kg, etc.)
            if token.nbor(1).text in ['g', 'kg', 'ml', 'mg', 'l', 'oz', 'lbs', 'lb']:
                value = token.text
                unit = token.nbor(1).text
                return value, unit


def extract_price_spacy(title):
    """Extract price using spaCy and regex for price formats like $45.99 or €30"""

    title = title.lower()  # Convert to lowercase
    doc = nlp(title)

    # First, try extracting price using regex (e.g., $45.99, €30)
    match = re.search(r'([€$£])?\s?(\d{1,3}(?:\.?\d{3})*(?:,\d{2})?)', title)
    if match:
        return match.group(0)

    # If regex doesn't match, attempt to infer the price from context (spaCy)
    for token in doc:
        if token.like_money:  # spaCy can recognize some currency symbols
            return token.text

    return "Unknown"

def extract_brand(title):
    """Extract brand using spaCy"""

    title = title.lower()  # Convert to lowercase
    doc = nlp(title)
    for ent in doc.ents:
        if ent.label_ == "ORG":  # Organization (brand name)
            return ent.text
    return "Unknown"

def extract_model(title):
    """Extract model or variant from the product title using spaCy and logic for product names."""
    
    title = title.lower()  # Convert to lowercase for consistency
    doc = nlp(title)
    
    # Initialize a list to store possible model components
    model_parts = []

    # Look for product-related entities in the title
    for ent in doc.ents:
        if ent.label_ == "MISC" or ent.label_ == "PRODUCT":
            model_parts.append(ent.text)
    
    # If no product model entities were found, we extract the title before the quantity or variant.
    if not model_parts:
        # We'll look for words before a quantity or variant (e.g., "100g", "500ml", or "Original")
        match = re.search(r'([A-Za-z0-9\s]+?)(?=\s(\d+(\.\d+)?(g|kg|ml|mg|l|oz|lbs|lb)|\s[^\w\s]+$))', title)
        if match:
            model_parts.append(match.group(1))
    
    # Join all model parts found and return it as the model name
    model = ' '.join(model_parts).strip()
    
    # If no model is found, return "Unknown"
    if model:
        return model.capitalize()  # Return the model with proper capitalization
    return "Unknown"

def scrape_product_page(url):
    try:
        # Send a GET request to the page
        response = requests.get(url)
        response.raise_for_status()  # Raise an error for invalid responses
        
        # Parse the page content with BeautifulSoup
        soup = BeautifulSoup(response.text, 'html.parser')

        # Find all product containers
        products = soup.find_all('div', class_='c-card-product')

        # Loop through each product and extract details
        for product_tag in products:
            title = product_tag.find('h6', class_='c-card-product__title').get_text(strip=True) if product_tag.find('h6', class_='c-card-product__title') else 'No Title'
            price = product_tag.find('div', class_='c-card-product__price').get_text(strip=True) if product_tag.find('div', class_='c-card-product__price') else 'No Price'
            brand = product_tag.find('div', class_='c-card-product__vendor').get_text(strip=True) if product_tag.find('div', class_='c-card-product__vendor') else 'No Brand' 
            old_price = product_tag.find('div', class_='c-card-product__price-old').get_text(strip=True) if product_tag.find('div', class_='c-card-product__price-old') else 'N/A'
            rating = product_tag.find('span', class_='rating')['aria-label'] if product_tag.find('span', class_='rating') else 'No Rating'
            vendor = product_tag.find('div', class_='c-card-product__vendor').get_text(strip=True) if product_tag.find('div', class_='c-card-product__vendor') else 'No Vendor'
            image_url = product_tag.find('img', class_='c-card-product__image')['src'] if product_tag.find('img', class_='c-card-product__image') else 'No image available'
            product_link = product_tag.find('a', class_='full-width-link')['href'] if product_tag.find('a', class_='full-width-link') else 'No link'
            
            # Use spaCy to extract the brand, model, price, and quantity
            model = extract_model(title)
            quantity = extract_quantity_spacy(title)
            price = extract_price_spacy(price)
            

            # Structure the product data
            product = {
                'title': title,
                'price': price,
                'oldPrice': old_price,
                'rating': rating,
                'vendor': vendor,
                'imageUrl': image_url,
                'productLink': product_link,
                'brand': brand,
                'model': model,
                'quantity': quantity,
            }

            # Print the structured product data
            print('Product Title:', product['title'])
            print('Brand:', product['brand'])
            print('Model:', product['model'])
            print('Quantity:', product['quantity'])
            print('Price:', product['price'])
            print('Image URL:', product['imageUrl'])
            print('Product Link:', product['productLink'])
            print('-' * 50)  # Separator for each product

    except requests.exceptions.RequestException as e:
        print(f"Error fetching the page: {e}")
    except AttributeError as e:
        print(f"Error parsing the page: {e}")

# Test the function with a sample product URL
scrape_product_page('https://allnutrition.cl/collections/whey-protein')
