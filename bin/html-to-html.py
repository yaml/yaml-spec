import sys
import requests
from bs4 import BeautifulSoup

html = sys.stdin.read()

soup = BeautifulSoup(html, "html.parser")

print(html)
