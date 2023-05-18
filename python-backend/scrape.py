import time
import re
import requests
from bs4 import BeautifulSoup
from dataclasses import dataclass
from typing import List, Tuple
import tiktoken

@dataclass
class Settings:
    url: str
    element: str
    title: str
    timeout: int
    datadir: str
    chunksize: int
    model: str

    def __call__(self, id: str) -> str:
        return self.url.replace("id", str(id))




def scrape_reviews(id: str, settings: Settings) -> Tuple[List[str], str]:
    url = settings(id)
    print(f"Start get request for {url}")

    response = requests.get(url, timeout=settings.timeout)
    print("Finished response")
    reviews = []
    if response.status_code == 200:
        print("Response status ok, start parsing")
        soup = BeautifulSoup(response.text, 'html.parser')
        matched_elements = soup.select(settings.element)
        titles = soup.select(settings.title)
        t = "0" if not titles else re.sub(r" |:|'", "", titles[0].text)
        for el in matched_elements:
            reviews.append(el.text)
    print(f"Finished scraping {id} with {len(reviews)} reviews")
    return reviews, t

def retry_if_empty(f, *args, **kwargs):
    res, t = f(*args, **kwargs)
    while not res:
        print("Empty result, retrying...")
        time.sleep(3)
        res, t = f(*args, **kwargs)
    return res, t

def strip_tokens(review: str, num_tokens: int, max_review_tokens: int) -> str:
    ratio = max_review_tokens / num_tokens
    trim_to_length = int(len(review) * ratio)
    return review[:trim_to_length]

def trim_review(reviews: List[str], max_review_tokens: int = 1024, model_name: str ="gpt-4") -> List[Dict]:
    encoding = tiktoken.encoding_for_model(model_name) 
    chunks = [] 
    
    for review in reviews:
        num_tokens = len(encoding.encode(review))
        if num_tokens > max_review_tokens:
            review = strip_tokens(review, num_tokens, max_review_tokens)
            num_tokens = max_review_tokens
        
        chunks.append({"content" : review, "tokencount": num_tokens})
    chunks.sort(key=lambda chunk: chunk["tokencount"], reverse=True)
    return chunks

def main(id: str, settings: Settings) -> Tuple[List[Dict], str]:
    reviews, title = retry_if_empty(scrape_reviews, id, settings)
    chunks = trim_review(reviews)
    return chunks, title
        

