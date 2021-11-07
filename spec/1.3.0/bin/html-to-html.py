import sys
import os.path

from bs4 import BeautifulSoup
import yaml

library_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'lib')

sys.path.append(library_path)

from transformations import transform


html = sys.stdin.read()
soup = BeautifulSoup(html, "html.parser")

with open(sys.argv[2], 'r') as file:
    links = yaml.load(file.read(), Loader=yaml.SafeLoader)

transform(soup, links)

sys.stdout.write(str(soup))
