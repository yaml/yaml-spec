import sys
import re
from copy import copy

from bs4 import BeautifulSoup, PageElement, NavigableString


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


def replace(element, expr, replacement):
    contents = []
    while len(element.contents):
        contents.append(element.contents[0].extract())

    for child in contents:
        if isinstance(child, NavigableString):
            element.append(expr.sub(replacement, str(child)))
        elif isinstance(child, PageElement):
            replace(child, expr, replacement)
            element.append(child)
        elif isinstance(child, str):
            element.append(re.sub(expr, replacement, child))
        else:
            raise TypeError(type(child))


def do_heading_stuff():
    toc_header = soup.find(id='toc-header')
    if toc_header is None:
        return

    structure = make_heading_structure(
        reversed(
            toc_header.find_all_next(lambda element: HEADING_EXPR.match(element.name))
        )
    )

    number_chapters(structure)
    number_examples()
    number_figures()

    toc = make_toc(structure)
    toc['id'] = 'markdown-toc'

    toc_header.parent.insert_after(toc)


def make_heading_structure(reversed_elements, level = 1):
    ret = []
    accumulated = []
    for element in reversed_elements:
        if element.name == 'h' + str(level):
            # section = element.wrap(tag('section'))
            # section
            ret.append((element, make_heading_structure(accumulated, level + 1)))
            accumulated = []
        else:
            accumulated.append(element)

    ret.reverse()
    return ret


HEADING_NUMBER_EXPR = re.compile(r'[#\dA-Z](\.[#\dA-Z])*(?=\. )')

def number_chapters(structure, numbers = []):
    heading_index = 1
    for heading, subheadings in structure:
        if heading.string and heading.string.startswith('Appendix') and isinstance(heading_index, int):
            heading_index = 'A'

        heading_path = numbers + [str(heading_index)]
        replace(heading, HEADING_NUMBER_EXPR, '.'.join(heading_path))
        heading.attrs['data-index'] = str(heading_index)
        number_chapters(subheadings, heading_path)

        if isinstance(heading_index, str):
            heading_index = chr(ord(heading_index) + 1)
        else:
            heading_index += 1


def number_examples():
    last_heading = None
    example_index = None
    for example in soup.find_all(class_='example'):
        example_heading = example.find('strong')
        if example_heading is None:
            continue
        heading = example_heading.find_previous('h1')
        if heading != last_heading:
            last_heading = heading
            example_index = 1
        chapter = '.'.join([heading['data-index'], str(example_index)])
        replace(example_heading, HEADING_NUMBER_EXPR, chapter)
        example_index += 1


def number_figures():
    last_heading = None
    figure_index = None
    for figure_heading in soup.find_all(lambda element:
        element.name == 'strong' and element.string and element.string.startswith('Figure #.')
    ):
        heading = figure_heading.find_previous('h1')
        if heading != last_heading:
            last_heading = heading
            figure_index = 1
        chapter = '.'.join([heading['data-index'], str(figure_index)])
        replace(figure_heading, HEADING_NUMBER_EXPR, chapter)
        figure_index += 1


def make_toc(structure):
    if len(structure) == 0:
        return None

    return tag('ul', [
        tag('li',
            tag('a', heading.contents, href='#' + heading['id']),
            make_toc(children),
        )
        for heading, children in structure
    ])


html = sys.stdin.read()

soup = BeautifulSoup(html, "html.parser")

do_heading_stuff()

sys.stdout.write(str(soup))
