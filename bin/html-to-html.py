import sys
import requests
from bs4 import BeautifulSoup

html = sys.stdin.read()

soup = BeautifulSoup(html, "html.parser")

html = html + "\n<!-- Smells like a snake was here -->"

print(html)
