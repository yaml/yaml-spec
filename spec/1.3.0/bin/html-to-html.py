import sys
import re
from copy import copy
import string

from bs4 import BeautifulSoup, PageElement, NavigableString
from roman import toRoman
import yaml


def warn(*args):
    print(*args, file=sys.stderr)


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
            matches = list(expr.finditer(child))
            if matches:
                text = child
                last_end = 0

                for match in expr.finditer(text):
                    start, end = match.span(0)

                    element.append(text[last_end:start])
                    if isinstance(replacement, str):
                        element.append(match.expand(replacement))
                    else:
                        element.append(replacement(match))

                    last_end = end

                element.append(text[last_end:])
            else:
                element.append(child)

        elif isinstance(child, PageElement):
            if child.name not in ('code', 'pre'):
                replace(child, expr, replacement)
            element.append(child)
        else:
            raise TypeError(type(child))


def slugify(string):
    ret = string.lower()
    ret = re.sub(r'\s+chapter\s\d+\.\s+', '', ret)
    ret = re.sub(r'^#+\s+(\d+\.)+', '', ret)
    ret = re.sub(r'[^a-z0-9]+', '-', ret)
    ret = ret.strip('-')
    return ret


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

    create_internal_links()


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


def create_internal_links():
    all_ids = {
        element['id']
        for element in soup.find_all(lambda tag: tag.has_attr('id'))
    }
    link_expr = re.compile(r'''
        \[ (?!\^)
          (
            (?![01]- | \d{3} )
            [^-\`\]]
            [^\]]*?
          )
        \]
        (?= [^\(\`]|$ )
    ''', re.X)

    def replace_link(match):
        target = match.group(1)
        if target.startswith('#'):
            href = '#rule-' + target[1:]
            return tag('sup', tag('a', '?', href=href), **{'class': 'rule-link'})
        else:
            id = link_index.get(slugify(target), link_index.get(slugify(target)+'s', '<nowhere>'))
            if id not in all_ids:
                warn("Warning: can't find id", repr(id), match.group(0))
            return tag('a', target, href='#'+id)

    replace(soup, link_expr, replace_link)


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
        (slug, target)
        for target, sources in links.items()
        if sources is not None
        for source in sources
        if (slug := slugify(str(source)))
    ]

    return {
        **{ slug+'s': target for slug, target in overrides },
        **{ id: id for id in ids },
        **{ slug: target for slug, target in overrides },
    }

html = sys.stdin.read()
soup = BeautifulSoup(html, "html.parser")

link_index = make_link_index()

do_heading_stuff()

sys.stdout.write(str(soup))
