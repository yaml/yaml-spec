import sys
import re
from copy import copy
import string

from bs4 import BeautifulSoup, PageElement, NavigableString
from roman import toRoman


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

    number_sections(soup, 'roman', 1)
    number_headings()
    number_examples()
    number_figures()

    toc = make_toc(soup)
    toc['id'] = 'markdown-toc'

    toc_header.parent.insert_after(toc)


def make_outline(elements):
    stack = []

    for element in elements:
        level = heading_level(element)
        if level is None:
            if stack:
                stack[-1].append(element.extract())
        else:
            while len(stack) >= level:
                stack.pop()

            section_attributes = {
                name: value
                for name, value in element.attrs.items()
                if name.startswith('data-section-')
            }
            section = element.wrap(tag('section', **section_attributes))

            if stack:
                stack[-1].append(section.extract())

            stack.append(section)


def number_sections(parent, section_format, start_index):
    if section_format == 'decimal':
        formatter = str
    elif section_format == 'roman':
        formatter = toRoman
    elif section_format == 'letter':
        formatter = lambda i: string.ascii_uppercase[i - 1]
    else:
        raise ValueError(f'Unknown section format {section_format!s}')

    index = start_index
    child_index = None
    for section in parent.find_all('section', recursive=False):
        section['data-section-number'] = formatter(index)
        if not section.attrs.get('data-section-continue'):
            child_index = 1
        child_index = number_sections(section, section.attrs.get('data-section-format', 'decimal'), child_index)
        index += 1

    return index


HEADING_NUMBER_EXPR = re.compile(r'#(\.#)*(?=\. )')


def number_headings():
    for heading in soup.find_all(['h1', 'h2', 'h3', 'h4', 'h5', 'h6']):
        heading_path = [
            section['data-section-number']
            for section in reversed(heading.find_parents('section'))
        ]
        if len(heading_path) > 1:
            heading_path = heading_path[1:]
        replace(heading, HEADING_NUMBER_EXPR, '.'.join(heading_path))


def number_examples():
    for part in soup.find_all('section', recursive=False):
        for section in part.find_all('section', recursive=False):
            chapter = section['data-section-number']
            for i, example in enumerate(section.find_all('div', class_='example'), 1):
                example_heading = example.find('strong')
                replace(example_heading, HEADING_NUMBER_EXPR, '.'.join([chapter, str(i)]))


def number_figures():
    for part in soup.find_all('section', recursive=False):
        for section in part.find_all('section', recursive=False):
            chapter = section['data-section-number']
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
