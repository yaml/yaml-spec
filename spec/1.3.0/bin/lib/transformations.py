import sys
import re
import string
from datetime import datetime

from roman import toRoman

from bs_util import new_tag, replace


__all__ = ['transform']


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
    ret = re.sub(r'^(chapter|appendix)\b', '', ret)
    ret = re.sub(r'[^a-z0-9]+', '-', ret)
    ret = ret.strip('-')
    return ret


def make_link_index(soup, links):
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


def transform(soup, links):
    # Hack so we don't have to explicitly pass the document into tag()
    global DOCUMENT
    DOCUMENT = soup

    toc_header = soup.find(id='toc-header')
    if toc_header is None:
        return

    make_outline(list(toc_header.parent.next_siblings))

    auto_id_dts(soup)
    auto_dates(soup)

    number_sections(soup, 'roman', 1)
    number_headings(soup)
    number_examples(soup)
    number_figures(soup)

    format_productions(soup)

    link_index = make_link_index(soup, links)

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

            section_id = slugify(''.join(element.strings))
            section_attributes = {
                name: value
                for name, value in element.attrs.items()
                if name.startswith('data-section-')
            }
            section = element.wrap(tag('section', id=section_id, **section_attributes))

            if stack:
                stack[-1].append(section.extract())

            stack.append(section)


def auto_id_dts(soup):
    for dt in soup.find_all('dt'):
        dt['id'] = slugify(''.join(dt.strings))


DATE_EXPR = re.compile(r'YYYY(.)MM(.)DD')
SHORT_DATE_EXPR = re.compile(r'YYYY')


def auto_dates(soup):
    today = datetime.today().date()
    replace(soup, DATE_EXPR, fr'{today.year:04}\g<1>{today.month:02}\g<2>{today.day:02}')
    replace(soup, SHORT_DATE_EXPR, fr'{today.year:04}')


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


PRODUCTION_EXPR = re.compile(r'''
    (?P<comment>\#.*) |
    \b(?P<name>
        [a-z]+(?:-[a-z0-9]+)+
    )\b
    (?![->])
    (?P<args>
        \( [^)]* \)
    )?
    (?=
        \s+ (?P<definition>::=)
    )?
''', re.X)


def format_productions(soup):
    productions = [
        pre for pre in soup.find_all('pre')
        if pre.string is not None
        and '::=' in pre.string
        and 'production-' not in pre.string
    ]

    all_names = set()

    for i, production in enumerate(productions, 1):
        production_name = PRODUCTION_EXPR.search(production.string).group('name')
        all_names.add(production_name)

        production['id'] = 'rule-' + production_name
        production['class'] = 'rule'

        production.insert(0, f'[{i}]')

    def link_production(m):
        name = m.group('name')
        if m.group('comment') is None and m.group('definition') is None:
            if name not in all_names:
                warn(f"Warning: Can't find rule {name}")

            return tag('a', m[0], href=f'#rule-{name}')
        else:
            return m[0]

    for production in productions:
        replace(production, PRODUCTION_EXPR, link_production)


def make_toc(parent):
    sections = parent.find_all('section', recursive=False)
    if len(sections) == 0:
        return None

    return tag('ul', [
        tag('li',
            tag('a', section.contents[0].contents, href='#' + section['id']),
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
