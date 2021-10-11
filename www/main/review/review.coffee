---
---
window.say = console.log
window.mmap = {}
window.nmap = {}
window.omap = {}

window.goto = (e)->
  e.scrollIntoView()

run = ()->
  [m, n, o] = $('iframe')
  $m = $(m.contentDocument)
  $n = $(n.contentDocument)
  $o = $(o.contentDocument)

  $n.find('h1,h2,h3,h4').each ->
    tag = @.tagName
    text = $(@).text()
      .replace(/^Chapter\s+(\d+\.)+\s+.*/, 'Chapter $1')
      .replace(/^(\d+\.)+\s+/, '')
    nmap["#{tag} #{text}"] = @

  $n.find('p').each ->
    children = @.childNodes
    if children.length == 1 and children[0].tagName == 'STRONG'
      text = $(children[0]).text()
        .replace(/\s+/g, ' ')
        .replace(/\s$/, '')
        .replace(/^Example\s+\d+\.\d+\s+/, 'Example ')
        .replace(/^Figure\s+\d+\.\d+\.\s+/, 'Figure ')
      nmap["HB #{text}"] = @

  $o.find('h1,h2,h3,h4').each ->
    tag = @.tagName
    text = $(@).text()

    if text.match /^\s*Chapter\s+\d+\.\s+/
      tag = 'H1'
    text = text
      .replace(/\s+/g, ' ')
      .replace(/^\s/, '')
      .replace(/\s$/, '')
      .replace(/^Chapter\s+(\d+\.)+\s+.*/, 'Chapter $1')
      .replace(/^(\d+\.)+\s+/, '')
    omap["#{tag} #{text}"] = @

  $o.find('B').each ->
    text = $(@).text()
      .replace(/^\s+/, '')
    return unless text.match /^(Figure|Example|Status|Abstract|Table)/
    text = text
      .replace(/\s+/g, ' ')
      .replace(/\s$/, '')
      .replace(/^Example\s+\d+\.\d+\.\s+/, 'Example ')
      .replace(/^Figure\s+\d+\.\d+\.\s+/, 'Figure ')
    omap["HB #{text}"] = @

  IO = $('iframe')[0].contentWindow.IntersectionObserver

  height = 200 - document.documentElement.scrollHeight

  mmap['# Chapter #. Introduction to YAML']     = 'H1 Chapter 1.'
  mmap['# Chapter #. Language Overview']        = 'H1 Chapter 2.'
  mmap['# Chapter #. Processes and Models']     = 'H1 Chapter 3.'
  mmap['# Chapter #. Syntax Conventions']       = 'H1 Chapter 4.'
  mmap['# Chapter #. Character Productions']    = 'H1 Chapter 5.'
  mmap['# Chapter #. Structural Productions']   = 'H1 Chapter 6.'
  mmap['# Chapter #. Flow Style Productions']   = 'H1 Chapter 7.'
  mmap['# Chapter #. Block Style Productions']  = 'H1 Chapter 8.'
  mmap['# Chapter #. Document Stream Productions'] = 'H1 Chapter 9.'
  mmap['# Chapter #. Recommended Schemas']      = 'H1 Chapter 10.'

  io = new IO (e)->
    return unless e[0].isIntersecting
    h = $(e[0].target).text()
    if mmap[h]?
      t = mmap[h]
    else if h.match /^(#{1,4})\s/
      l = RegExp.$1
      l = l.length
      h = h.replace /^#+\s+/, ''
      h = h.replace(/^\#\.\s+/, '')
      t = "H#{l} #{h}"
    else if h.match /^\*\*/
      h = h
        .replace(/^\*\*/, '')
        .replace(/\*\*$/, '')
        .replace(/\s+/g, ' ')
        .replace(/Example\s+\#\.\s+/, 'Example ')
        .replace(/Figure\s+\#\.\s+/, 'Figure ')
      t = "HB #{h}"

    try
      goto nmap[t]

    try
      goto omap[t]
  ,
  rootMargin: "0px 0px #{height}px 0px"
  threshold: [1]

  $m.find('code').each ->
    io.observe(@)

$(document).ready ->
  m = $('iframe')[0].contentDocument
  n = $('iframe')[1].contentDocument
  o = $('iframe')[2].contentDocument
  wait = ->
    say 'wait'
    if m.readyState == 'complete' and
       n.readyState == 'complete' and
       o.readyState == 'complete'
      setTimeout ->
        run()
      , 500
    else
      setTimeout wait, 500
  wait()
