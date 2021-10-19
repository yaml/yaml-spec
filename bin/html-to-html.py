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

    structure = make_heading_structure(
        element
        for element in reversed(soup.contents)
        if isinstance(element.name, str) and HEADING_EXPR.match(element.name)
    )

    toc = make_toc_recursive(structure)
    toc['id'] = 'markdown-toc'

    toc_header.parent.insert_after(toc)


def make_heading_structure(reversed_elements, level = 1):
    ret = []
    accumulated = []
    for element in reversed_elements:
        if element.name == 'h' + str(level):
            ret.append((element, make_heading_structure(accumulated, level + 1)))
            accumulated = []
        else:
            accumulated.append(element)

    ret.reverse()
    return ret


def make_toc_recursive(structure):
    if len(structure) == 0:
        return None

    return tag('ul', [
        tag('li',
            tag('a', heading.contents, href='#' + heading['id']),
            make_toc_recursive(children),
        )
        for heading, children in structure
    ])


html = sys.stdin.read()

soup = BeautifulSoup(html, "html.parser")

make_toc()

sys.stdout.write(str(soup))
