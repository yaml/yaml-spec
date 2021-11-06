import sys
import os.path

from bs4 import BeautifulSoup
import yaml

library_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'lib')

sys.path.append(library_path)

from transformations import transform, slugify


def make_link_index():
    links_path = sys.argv[2]

    with open(links_path, 'r') as file:
        links_text = file.read()
        links = yaml.load(links_text, Loader=yaml.SafeLoader)

    ids = [
        slugify(element['id'])
        for element in soup.find_all(lambda tag: tag.has_attr('id'))
    ]

    overrides = [
        (slugify(str(source)), target)
        for target, sources in links.items()
        if sources is not None
        for source in sources
    ]

    return {
        **{ slug+'s': target for slug, target in overrides },
        **{ id: id for id in ids },
        **{ slug: target for slug, target in overrides },
    }


html = sys.stdin.read()
soup = BeautifulSoup(html, "html.parser")

link_index = make_link_index()

transform(soup, link_index)

sys.stdout.write(str(soup))
