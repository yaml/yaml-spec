from copy import copy
from bs4 import BeautifulSoup, PageElement, NavigableString


__all__ = ['new_tag', 'replace']


def new_tag(soup, name, *contents, **attrs):
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
