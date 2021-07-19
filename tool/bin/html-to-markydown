#!/usr/bin/env coffee

require 'ingy-prelude'
Turndown = require 'turndown'
Node = require 'domino/lib/Node'
wrap = require 'smartwrap'
yaml = require 'yaml'

tag_and_class = (tag, class_)->
  (n, o)->
    n.nodeName == tag.toUpperCase() and
    n.getAttribute('class') == class_

r = (re)-> HtmlToMarkdown.re[re].toString()[1...-1]


class HtmlToMarkdown
  constructor: (legend_file)->
    HtmlToMarkdown.legend = yaml.parse file_read legend_file

    @turndown = new Turndown
      headingStyle: 'atx'
      preformattedCode: true
      codeBlockStyle: 'fenced'
      linkStyle: 'inlined'
      hr: '----'

    for k, v of @constructor.rules
      @turndown.addRule k, v

  convert: (html)->
    html = html
      .replace(/[“”]/g, '"')

    markdown = @turndown.turndown html
      .replace(/.*\n.*\n/, '')
      .replace(/^(###.*)\n\n</gm, '$1 <')
      .replace(/"""/g, "'\"'")
      .replace(/^  $/mg, '')
      .replace(/  \n/g, '')
      .replace(/\n\n\n+/g, "\n\n")
      .replace(/^> $/mg, '>')
      .replace(/^\d\.\ +/mg, '1. ')
      .replace(/\xa0/g, ' ')
      .replace(/YYYY/g, '2009')
      .replace(/-MM/g, '-10')
      .replace(/-DD/g, '-01')
      .replace(/\[\d+\](?=.*::=)/g, '[#]')
      .replace(/[“”]/g, '"')

    return markdown + "\n"

  @H:
    H1: '#'
    H2: '##'
    H3: '###'
    H4: '####'

  @rules:
    authorgroup:
      filter: tag_and_class 'div', 'authorgroup'
      replacement: (m, n, o)->
        text = m
          .replace(/### /g, '* **')
          .replace(/\n\n</g, ' <')
          .replace(/>/g, '>**')
          .replace(/\n\n/g, "\n")
          .replace(/^\s+/, '')
        return """\
          #{text}\
          {:.authorgroup}
          """

    releaseinfo:
      filter: tag_and_class 'p', 'releaseinfo'
      replacement: (m, n, o)->
        return m
          .replace(/^\s+(.*)  $/mg, '* $1')
          .replace(/^_(.*)_  $/m, "**$1**\n")
          .replace(
            /^_(.*)_ (.*)  $/m,
            "{:.releaseinfo}\n\n**$1**\n$2")

    toc:
      filter: tag_and_class 'div', 'toc'
      replacement: (m, n, o)->
        return """\
          **Contents**

          ::toc
          """

    index:
      filter: tag_and_class 'div', 'index'
      replacement: (m, n, o)->
        return "::index\n"

    simplelist:
      filter: tag_and_class 'table', 'simplelist'
      replacement: (m, n, o)=>
        return m unless m.match /\[\d+\]/
        return m.replace ///^
          #{r'A'}*
          ( #{r'pre_block'} )
          \s*
          (\S#{r'A'}+?\S)
          \s*
        $///,
          (m, m1, m2)=>
            if m2.match /grave /
              m2 = m2.replace /```/, '<code>&grave;</code>'
            """\
            #{@do.reformat m2}
            #{m1}

            """

    subtitle:
      filter: tag_and_class 'h2', 'subtitle'
      replacement: (m, n, o)->
        return """\
          **#{m}**
          """

    indexdiv:
      filter: tag_and_class 'div', 'indexdiv'
      replacement: (m, n, o)->
        return m.replace /### (.*)/, '**$1**'

    informaltable:
      filter: tag_and_class 'div', 'informaltable'
      replacement: (m, n, o)=>
        table = ''
        for tr, i in n.getElementsByTagName 'TR'
          a = @do.getRowData tr
          table += '| ' + a.join(' | ') + "\n"
          if i == 0
            table += '| ' + _.repeat('-- | ', a.length - 1) + "--\n"

        return table + "\n"

    production:
      filter: (n, o)->
        n.nodeName == 'TR' and
        n.firstChild.getAttribute('class') == 'productioncounter'
      replacement: (m, n, o)=>
        num = n.getElementsByClassName('productioncounter')[0].textContent
        lhs = n.getElementsByClassName('productionlhs')[0].textContent
        op  = n.getElementsByClassName('productionseperator')[0].textContent
        a = []
        @do.getTexts(n.getElementsByClassName('productionrhs')[0], a)
        rhs = a.join ''
        if rhs.match /\ /
          rhs = "\n  #{rhs}"
        else
          op += ' '

        rhs = rhs.replace /\s+$/, ''

        return """
          ```
          #{num} #{lhs} #{op}#{rhs}
          ```\n\n
          """

    example:
      filter: tag_and_class 'div', 'example'
      replacement: (m, n, o)=>
        text = m

        RegExp.$1 = ''

        re = /^(\*\*(?:[\s\S](?!```))*\*\*)\n/
        if text.match re
          text = text.replace re, ''
          title = RegExp.$1 or
            XXX ['no title', m]

        legend = ''
        re = /```\n\s*Legend:\n([\s\S]+?)\n```\n\n/
        if text.match re
          text = text.replace re, ''
          legend = @fmt_legend RegExp.$1

        re = /```\n([\s\S]+?)\n```\n\n/
        if text.match re
          text = text.replace re, ''
          yaml1 = @fmt_pre RegExp.$1 or
            XXX ['no yaml1', text, m]

        yaml2 = ''
        if text.match re
          text = text.replace re, ''
          yaml2 = @fmt_pre RegExp.$1

        if text.match /\S/
          XXX
            _: 'Bad Example'
            input: m
            title: title
            yaml1: yaml1
            yaml2: yaml2
            legend: legend

        out = "#{title}\n#{yaml1}"
        out += yaml2 if yaml2
        out += legend if legend
        out += "\n"

        return out

    example_break:
      filter: tag_and_class 'br', 'example-break'
      replacement: (m, n, o)-> ''

    node_comparison:
      filter: (n, o)->
        n.nodeName == 'DIV' and
        n.getAttribute('class') == 'variablelist' and
        n.innerHTML.match /(?:YAML therefore requires|Identity should not)/
      replacement: (m, n, o)->
        text = m
          .replace(/^>\ /mg, '')
          .replace(/^\ +$/mg, '')
        text.replace /^(\*.*\n(?:\S.*\n)+)/mg, (m, m1)->
          m1.replace(/^(?=[^\*])/mg, '  ')

    p:
      filter: (n, o)->
        n.nodeName == 'P' and
        n.getAttribute('class') != 'releaseinfo'
      replacement: (m, n, o)=>
        text = m.replace(
          /^(\*\*(?:Figure|Example)\s)(?:\d+\.)+\s+([\s\S]*\*\*)\s*$/,
          (m, m1, m2)->
            "#{m1}#. #{m2.replace /\s+/g, ' '}"
        )
        if n.parentNode.nodeName in ['LI', 'DD']
          width = 77
        else
          width = 79
        return @do.reformat(text, width) + "\n\n"

    heading:
      filter: (n, o)->
        n.nodeName.match(/^H[1-4]$/) and
        n.getAttribute('class') == 'title'
      replacement: (m, n, o)=>
        mark = @H[n.nodeName]
        return "#{mark} #{m}" unless m.match /\d+\.\s/
        if m.match(/^Chapter/)
          mark = '#'
        text = m
          .replace(/(\d+\.)+\s/, '#. ')
        "#{mark} #{text}"

    link:
      filter: tag_and_class 'a', 'link'
      replacement: (m, n, o)->
        return "[#{m}]"

    itemizedlist:
      filter: tag_and_class 'div', 'itemizedlist'
      replacement: (m, n, o)=>
        text = m.replace /\s*$/, ''
        if text.match /\. [A-Z]/
          text = text.replace(/^\s*\*\s+/, '')
          text = @do.reformat(text, 77)
            .replace(/^/mg, '  ')
            .replace(/./, '*')
        text
          .replace(/^\s+/, '')
          .replace(/^\*   /mg, '* ')
          .replace(/^    /mg, '  ')
          .replace(/\s*$/g, "\n")

    img:
      filter: 'img'
      replacement: (m, n, o)->
        img = n._attrsByQName.src.data
        alt = n._attrsByQName.alt.data
        return "![#{alt}](img/#{img})"

    pre:
      filter: 'pre'
      replacement: (m, n, o)->
        pre = m
          .replace(/^\\/gm, '')
          .replace(/\\([\[\]\*])/g, '$1')
          .replace(/\ +$/mg, '')
          .replace(/\\\\/g, '\\')
          .replace(/\\_/g, '_')
          .replace(/\\#/g, '#')
          .replace(/`(.*?)`/g, '$1')
          .replace(/([^`])`(?=[^`])/g, '$1')
        return """
          ```
          #{pre}
          ```\n\n
          """

    dt:
      filter: 'dt'
      replacement: (m, n, o)->
        text = m
        text = "##### #{text.replace(/\s+$/, '')}" \
          unless text.match /\*\*/
        return "#{text}\n\n"

    dd:
      filter: 'dd'
      replacement: (m, n, o)=>
        text = @do.reformat(m)
        text = text
          .replace(/\n+$/, '')
          .replace(/^/mg, '> ')
        return text + "\n\n"

    code:
      filter: 'code'
      replacement: (m, n, o)->
        if m.match /^<.*mailto/
          return m
        else
          return "`#{m}`"

  @re:
    A: /[\s\S]/
    pre_block: ///
      ```\n
      [\s\S]+\n
      ```\n
    ///

  @do:
    getTexts: (node, a)=>
      if node.nodeType == Node.TEXT_NODE
        a.push node._data
      else if node.nodeName == 'BR'
        a.push "\n  "
      else
        for n in node.childNodes
          @do.getTexts n, a

    getRowData: (tr)->
      a = []
      for td in tr.childNodes
        a.push _.trim(td.textContent) || ' '
      return a

    reformat: (text, width=79)->
      text = text.replace /\ \ $/mg, '%%%'
      text = text.replace ///
          ([\s\S]+?)
          (?:
            ([^\#]\.)\ (?=[A-Z])
          |
            $
          )
        ///g,
        (x, s, e='')->
          wrap(s, width: width) + "#{e}\n"
      text = text.replace /%%%$/mg, '  '
      return text

  @fmt_pre: (text)->
    return '' unless text
    text = text
      .replace(/^\s+/, '')
      .replace(/\s+$/, "\n")
      .replace(/([^`])`(?=[^`])/g, '$1')
      .replace(/^`/, '')
      .replace(/`$/, '')
    return "```\n#{text}\n```\n"

  @fmt_legend: (text)=>
    return '' unless text
    text = text
      .replace(/^\s+/, '')
      .replace(/\s+$/, '')
      .replace(/\]\s+/g, "]\n")
      .replace(/\)\s+\[/g, ")\n[")
      .replace(/\]\s+(Not|Value)/g, "] $1")
      .replace(/(\[c-sequence-start\])\s+(\[c-sequence-end\])/, "$1 $2")
      .replace(/(\[c-mapping-start\])\s+(\[c-mapping-end\])/, "$1 $2")
      .replace(/^\s*/mg, '* ')

    legend = @legend.shift()

    if legend? and legend[0]
      for l in legend
        text = text.replace /\]$/m, "] <!-- #{l} -->"

    return """
      **Legend:**
      #{text}\n
      """


main = (spec, links, legend)->
  to_markdown = new HtmlToMarkdown links, legend

  html = file_read spec

  out to_markdown.convert(html)


main process.argv[2..]...
