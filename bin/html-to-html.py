import sys
import re
from copy import copy

from bs4 import BeautifulSoup, PageElement


HEADING_EXPR = re.compile(r'\Ah\d\Z')


def tag(name, *contents, **attrs):
    ret = soup.new_tag(name, **attrs)
    for child in flatten(contents):
        ret.append(child)
    return ret


def flatten(value):
    if value is None:
        pass
    elif isinstance(value, PageElement):
        yield copy(value)
    elif isinstance(value, str):
        yield value
    elif iterable(value):
        for item in value:
            yield from flatten(item)
    else:
        yield value


def iterable(value):
    try:
        iter(value)
        return True
    except TypeError:
        return False


def make_toc():
    toc_header = soup.find(id='toc-header')
    if toc_header is None:
        return

    headings = [
        element
        for element in soup.contents
        if isinstance(element.name, str) and HEADING_EXPR.match(element.name)
    ]

    toc = make_toc_recursive(1, headings)
    toc['id'] = 'markdown-toc'

    toc_header.parent.insert_after(toc)


def split_heading_reversed(elements, name):
    acc = []
    for element in reversed(elements):
        if element.name == name:
            acc.reverse()
            yield (element, acc)
            acc = []
        else:
            acc.append(element)


def make_toc_recursive(level, elements):
    structure = list(split_heading_reversed(elements, 'h'+str(level)))

    if len(structure) == 0:
        return None

    return tag('ul', [
        tag('li',
            tag('a', heading.contents, href='#'+heading['id']),
            make_toc_recursive(level + 1, children),
        )
        for heading, children in reversed(structure)
    ])


html = sys.stdin.read()

soup = BeautifulSoup(html, "html.parser")

make_toc()

sys.stdout.write(str(soup))
