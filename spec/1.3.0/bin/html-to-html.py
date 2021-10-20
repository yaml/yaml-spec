import sys
import re
from copy import copy

from bs4 import BeautifulSoup, PageElement, NavigableString


HEADING_EXPR = re.compile(r'\Ah(\d)\Z')

def heading_level(element):
    if element.name:
        match = HEADING_EXPR.match(element.name)
        if match is not None:
            return int(match.group(1))
    return None


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

    make_outline(list(toc_header.parent.next_siblings))

    number_chapters(soup)
    number_examples()
    number_figures()

    toc = make_toc(soup)
    toc['id'] = 'markdown-toc'

    toc_header.parent.insert_after(toc)


def make_outline(elements):
    stack = []
    path = []

    for element in elements:
        level = heading_level(element)
        if level is None:
            if stack:
                stack[-1].append(element.extract())
        else:
            previous_index = 0

            while len(stack) >= level:
                stack.pop()
                previous_index = path.pop()

            if isinstance(previous_index, int) and element.string and element.string.startswith('Appendix'):
                # Special case for appendices
                index = 'A'
            elif isinstance(previous_index, str):
                index = chr(ord(previous_index) + 1)
            else:
                index = previous_index + 1

            section = element.wrap(tag('section', **{'data-section-number': index}))

            if stack:
                stack[-1].append(section.extract())

            stack.append(section)
            path.append(index)


HEADING_NUMBER_EXPR = re.compile(r'#(\.#)*(?=\. )')


def number_chapters(parent, numbers = []):
    for section in parent.find_all('section', recursive=False):
        heading = section.contents[0]
        heading_path = numbers + [str(section['data-section-number'])]

        replace(heading, HEADING_NUMBER_EXPR, '.'.join(heading_path))

        number_chapters(section, heading_path)


def number_examples():
    for section in soup.find_all('section', recursive=False):
        chapter = str(section['data-section-number'])
        for i, example in enumerate(section.find_all('div', class_='example'), 1):
            example_heading = example.find('strong')
            replace(example_heading, HEADING_NUMBER_EXPR, '.'.join([chapter, str(i)]))


def number_figures():
    for section in soup.find_all('section', recursive=False):
        chapter = str(section['data-section-number'])
        figure_headings = section.find_all(lambda element:
            element.name == 'strong' and element.string and element.string.startswith('Figure #.')
        )
        for i, figure_heading in enumerate(figure_headings, 1):
            replace(figure_heading, HEADING_NUMBER_EXPR, '.'.join([chapter, str(i)]))


def make_toc(parent):
    sections = parent.find_all('section', recursive=False)
    if len(sections) == 0:
        return None

    return tag('ul', [
        tag('li',
            tag('a', section.contents[0].contents, href='#' + section.contents[0]['id']),
            make_toc(section),
        )
        for section in sections
    ])


html = sys.stdin.read()

soup = BeautifulSoup(html, "html.parser")

do_heading_stuff()

sys.stdout.write(str(soup))
