#Tool that scrapes html given a url

import requests
from bs4 import BeautifulSoup as bs
import json
import regex as re

def jprint(obj):
    # create a formatted string of the Python JSON object
    text = json.dumps(obj, sort_keys=True, indent=4)
    print(text)
    return

def fetch(url):
    #takes in a url, scrapes the data and returns the bs object 
    request = requests.get(url)
    if request.status_code != requests.codes.ok:
        raise ImportError('bad get request')
    types = request.headers.get('Content-Type')
    if "text" in types: 
        page = request.text
    elif "json" in  types:
        page = request.json()
    else:
        raise TypeError('bad typing')
    soup = bs(page, "html.parser")
    print(soup.prettify)
    '''text = [p.text for p in soup.find(class_="post-content").find_all('p')]'''
    return soup
    
url = 'https://www.dataquest.io/blog/python-api-tutorial/'
f = fetch(url)

def trim(soup, c, all = 0):
    #returns wanted info from soup
    if all == 0:
        items = [item.text for item in soup.find(class_=c).find_all(re.compile("^b"))] 
    else:
        items = [item.text for item in soup.find(class_=c).find_all('p')]
    return

g = trim(f, 'div')
