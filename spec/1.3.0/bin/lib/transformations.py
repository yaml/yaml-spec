import sys
import re
import string

from roman import toRoman

from bs_util import new_tag, replace

def warn(*args):
    sys.stderr.write('\033[0;31m')
    print(*args, file=sys.stderr, end='\033[0m\n')


DOCUMENT = None
def tag(name, *contents, **attrs):
    return new_tag(DOCUMENT, name, *contents, **attrs)


HEADING_EXPR = re.compile(r'h(\d)')

def heading_level(element):
    if element.name:
        match = HEADING_EXPR.fullmatch(element.name)
        if match is not None:
            return int(match.group(1))
    return None


def slugify(string):
    ret = string.lower()
    ret = re.sub(r'\s+chapter\s\d+\.\s+', '', ret)
    ret = re.sub(r'^#+\s+(\d+\.)+', '', ret)
    ret = re.sub(r'[^a-z0-9]+', '-', ret)
    ret = ret.strip('-')
    return ret


def transform(soup, link_index):
    # Hack so we don't have to explicitly pass the document into tag()
    global DOCUMENT
    DOCUMENT = soup

    toc_header = soup.find(id='toc-header')
    if toc_header is None:
        return

    make_outline(list(toc_header.parent.next_siblings))

    number_sections(soup, 'roman', 1)
    number_headings(soup)
    number_examples(soup)
    number_figures(soup)

    toc = make_toc(soup)
    toc['id'] = 'markdown-toc'

    toc_header.parent.insert_after(toc)

    create_internal_links(soup, link_index)


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
        child_index = number_sections(
            section,
            section.attrs.get('data-section-format', 'decimal'),
            child_index
        )
        index += 1

    return index


HEADING_NUMBER_EXPR = re.compile(r'#(\.#)*(?=\. )')


def number_headings(soup):
    for heading in soup.find_all(['h1', 'h2', 'h3', 'h4', 'h5', 'h6']):
        heading_path = [
            section['data-section-number']
            for section in reversed(heading.find_parents('section'))
        ]
        if len(heading_path) > 1:
            heading_path = heading_path[1:]
        replace(heading, HEADING_NUMBER_EXPR, '.'.join(heading_path))


def number_examples(soup):
    for part in soup.find_all('section', recursive=False):
        for section in part.find_all('section', recursive=False):
            chapter = section['data-section-number']
            for i, example in enumerate(section.find_all('div', class_='example'), 1):
                example_heading = example.find('strong')
                replace(example_heading, HEADING_NUMBER_EXPR, '.'.join([chapter, str(i)]))


def number_figures(soup):
    for part in soup.find_all('section', recursive=False):
        for section in part.find_all('section', recursive=False):
            chapter = section['data-section-number']
            figure_headings = section.find_all(lambda element:
                element.name == 'strong' and
                element.string and
                element.string.startswith('Figure #.')
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


def create_internal_links(soup, link_index):
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
            id = link_index.get(
                slugify(target),
                link_index.get(slugify(target)+'s',
                '<nowhere>')
            )
            if id not in all_ids:
                warn("Warning: can't find id", repr(id), match.group(0))
            return tag('a', target, href='#'+id)

    replace(soup, link_expr, replace_link)
