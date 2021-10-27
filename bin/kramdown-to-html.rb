require 'kramdown'

options = {
  input: 'GFM',
  parse_block_html: true,
  hard_wrap: false,
  syntax_highlighter_opts: {
    default_lang: 'plaintext',
    guess_lang: true,
  }
}

document = Kramdown::Document.new(STDIN.read, options)
STDOUT.write document.to_html
