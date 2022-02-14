import sys
import re
import string
import itertools
from datetime import datetime

from roman import toRoman

from bs_util import new_tag, replace, next_tag, next_comments, pretty_path

from bs4 import Comment


__all__ = ['transform']


def warn(*args):
    sys.stderr.write('\033[0;31m')
    print(*args, file=sys.stderr, end='\033[0m\n')


DOCUMENT = None
def tag(name, *contents, **attrs):
    return new_tag(DOCUMENT, name, *contents, **attrs)


def next_available_id(slug):
    return next(
        id
        for id in itertools.chain([slug], (f'{slug}-{i}' for i in itertools.count(1)))
        if DOCUMENT.find(id=id) is None
    )


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
    number_figures(soup)

    production_names = format_productions(soup)
    format_examples(soup, production_names)
    number_examples(soup)

    link_index = make_link_index(soup, links)

    toc = make_toc(soup)
    toc['id'] = 'markdown-toc'

    toc_header.parent.insert_after(toc)

    create_internal_links(soup, link_index)

    check_for_duplicate_ids(soup)


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

            section_id = next_available_id(slugify(''.join(element.strings)))
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
        dt['id'] = next_available_id(slugify(''.join(dt.strings)))


DATE_EXPR = re.compile(r'YYYY(.)MM(.)DD')
SHORT_DATE_EXPR = re.compile(r'YYYY')


def auto_dates(soup):
    today = datetime.utcnow().date()
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

    return all_names


HIGHLIGHT_EXPR = re.compile(r"""
    (?P<row>\d+)
    (?:
        :
        (?P<col_start>\d+)
        (?:
            (?P<comma>,)
            (?P<length>\d+)?
        )?
    )?
""", re.X)


def regexp_escape(s):
    return re.sub(r'([\[\]\(|)\{\}\?\*\+\#\|\\])', r'\\\1', s)


def format_examples(soup, production_names):
    def replace_legend_link(match):
        production_match = PRODUCTION_EXPR.match(match[1])
        if production_match:
            name = production_match.group('name')
        else:
            raise ValueError(f'Invalid rule name {match[1]}')

        if name not in production_names:
            warn(f"Warning: Can't find rule {name}")

        return tag('a', match[1], href=f'#rule-{name}')

    def get_highlights(lines, comments):
        for comment, mark_index in comments:
            parts = str(comment).strip().split(' ')
            literal_parts = []
            for part in parts:
                m = HIGHLIGHT_EXPR.fullmatch(part)
                if m is None:
                    literal_parts.append(part)
                else:
                    row = int(m.group('row'))
                    if m.group('col_start') is not None:
                        col_start = int(m.group('col_start')) - 1
                        if m.group('length') is not None:
                            length = int(m.group('length'))
                        elif m.group('comma') is not None:
                            length = len(lines[row - 1]) - col_start
                        else:
                            length = 1
                    else:
                        col_start = 0
                        length = len(lines[row - 1])

                    yield (row, col_start, col_start + length, mark_index)

            if literal_parts:
                pattern = r'|'.join(
                    regexp_escape(part).replace('_', ' ')
                    for part in literal_parts
                )
                for row, line in enumerate(lines, 1):
                    for m in re.finditer(pattern, line):
                        yield (row, m.start(0), m.end(0), mark_index)

    def format_pre(pre, comments):
        lines = pre.get_text().removeprefix('\n').removesuffix('\n').split('\n')

        highlights = list(get_highlights(lines, comments))
        highlights.sort(key=lambda h: (h[0], h[1], -h[2], h[3]))

        pre.clear()
        pre.append('\n')

        for parent_row, line in enumerate(lines, 1):
            def highlight_part(parent_start, parent_end):
                i = parent_start
                while highlights:
                    row, col_start, col_end, mark_index = highlights[0]
                    if row != parent_row or col_start >= parent_end:
                        break
                    highlights.pop(0)
                    yield line[i:col_start]
                    yield tag(
                        'mark',
                        highlight_part(col_start, col_end),
                        class_=f'legend-{mark_index}',
                    )
                    i = col_end
                yield line[i:parent_end]

            for x in highlight_part(0, len(line)):
                pre.append(x)

            pre.append('\n')

        pre.prettify()

    example_headings = [
        element.parent
        for element in soup.find_all('strong')
        if element is not None
        and element.get_text().startswith('Example')
    ]

    for example_heading in example_headings:
        example_id = slugify(re.sub(r'\s*\(.*', '', example_heading.get_text()))
        example = example_heading.wrap(
            tag('div', class_='example', id=example_id)
        )

        # Find parts of example

        first_block = None
        first_comments = []
        second_block = None
        second_comments = []
        legend_heading = None
        legend_list = None

        t = next_tag(example)
        if t is not None and t.name == 'pre':
            first_block = t.extract()

            for i, comment in enumerate(next_comments(example), 1):
                first_comments.append((comment.extract(), i))

            t = next_tag(example)

            if t is not None and t.name == 'pre':
                second_block = t.extract()

                for i, comment in enumerate(next_comments(example), 1):
                    second_comments.append((comment.extract(), i))

                t = next_tag(example)

        if t is not None and t.get_text().strip() == 'Legend:':
            legend_heading = t.extract()
            t = next_tag(example)

            if t is not None and t.name == 'ul':
                legend_list = t.extract()

        # Format

        if legend_list is not None:
            for i, li in enumerate(legend_list.find_all('li'), 1):
                comment = li.find(string=lambda node: isinstance(node, Comment))
                if comment is not None:
                    first_comments.append((comment.extract(), i))

                code = tag('code', class_=f'legend-{i}')
                for child in li.contents:
                    code.append(child.extract())

                    if code.string is not None:
                        code.append(code.string.extract().strip(' '))

                replace(code, LINK_EXPR, replace_legend_link)
                li.append(code)

        format_pre(first_block, first_comments)
        if second_block is not None:
            if re.match(r'\A\n?(?:[\{\[]\ |"|!)', second_block.get_text()):
                second_block.code['class'] = 'language-json'
            else:
                format_pre(second_block, second_comments)

        # Output

        if second_block is not None:
            if second_block.get_text().startswith('\nERROR:'):
                first_block['class'] = 'error'
                second_block['class'] = 'error'

            example.append(tag('table', tag('tr',
                tag('td', first_block, class_='side-by-side'),
                tag('td', second_block, class_='side-by-side'),
            ), width='100%'))
        else:
            first_block['class'] = 'example'
            example.append(first_block)

        if legend_list is not None:
            example.append(tag('div', legend_heading, legend_list, class_='legend'))


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


LINK_EXPR = re.compile(r'''
    \[ (?!\^)
      (
        (?![01]- | \d{3} )
        [^-\`\]]
        [^\]]*?
      )
    \]
    (?= [^\(\`]|$ )
''', re.X)

def create_internal_links(soup, link_index):
    all_ids = {
        element['id']
        for element in soup.find_all(lambda tag: tag.has_attr('id'))
    }

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

    replace(soup, LINK_EXPR, replace_link)


def check_for_duplicate_ids(soup):
    grouped = {}
    for element in soup.find_all(lambda tag: tag.has_attr('id')):
        grouped.setdefault(element['id'], []).append(element)

    for id, elements in grouped.items():
        if len(elements) > 1:
            warn(f"Warning: multiple elements with ID {id!r}")
            for element in elements:
                warn('    ' + pretty_path(element))
