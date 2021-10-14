#!/usr/bin/env perl

use v5.18;
use Encode;

use YAML::PP;
use XXX;

my ($YYYY, $MM, $DD);
my (@heading_level) = (0, 0, 0, 0);
my $links = {};

sub main {
  my ($front, $markdown, $link_map) = read_files(@_);

  my $parsed = parse_sections($markdown);

  set_vars();
  make_link_index($parsed, $link_map);

  my @sections;
  for my $section (@$parsed) {
    my ($key) = keys %$section;
    my $method = "fmt_$key";
    $_ = $section->{$key};
    main->$method;
    push @sections, $_;
  }

  print encode_utf8 $front;
  print encode_utf8 join "\n", @sections;
}

#------------------------------------------------------------------------------
my $x = '(?s:.)';
my $s = '\ ';
my $line = '(?:.*\n)';
my $line_not_blank = '(?:(?:.*\S.*\n)|\n(?=\ \ ))';
my $comment = '(?s:<!--.*?-->\n)';
my $li = '(?:\*\ \S.*\n)';
my $b = '\*\*';
my $code = '```\n';
my $html = '<((?:[a-z]+)).*?>\n';
my $ial = '(?:\{:.+?\}\n)';

my $re_pre = qr/
  $code
  $line+?
  $code
  $ial*
  $comment*
  \n*
/x;

my $re_legend = qr/
  ${b}Legend:$b\n
  $li+
  \n*
/x;

sub parse_sections {
  ($_) = @_;

  my @s;
  while ($_) {
    # Example section:
    s<\A
      (${b}Example$s\# $x*?$b)\n+
      ($re_pre)
      ($re_pre)?
      ($re_legend)?
      \n+
    ><>x
      and push @s, {example => [$1, $2, $3, $4]} and next;

    # HTML block:
    if (/\A$html/) {
      my $tag = $1;
      s{\A
        (
          $html
          $line*?
          </$tag>
          \n*
        )
      }{}x and push @s, {html_block => $1} and next;
    }

    # Headings:
    s{\A
      (\S$line)
      ===+ \n
      \n+
    }{}x and push @s, {heading => "# $1"} and next;

    s/\A(#{1,5} .*\n$ial?)\n+//
      and push @s, {heading => $1} and next;

    # Definition term:
    s/\A(\w.*)(?=\n:)\n+//
      and push @s, {dt => $1} and next;

    # Definition definition:
    s{\A
      (
        : (?:\n|$s+) $line
        (?:
          (?: \S | \ \ \S) $line
        )*?
      )
      (?:
        (?= : ) |
        \n+
      )
    }{}x and push @s, {dd => $1} and next;

    # Unordered list:
    s/\A
      (
        $ial*
        $li
        $line_not_blank*
        $ial*
      )
      \n+
    //x and push @s, {ul => $1} and next;

    # Unordered list:
    s{\A
      (
        $li
        (?:
          $s$s$line |
          \n(?=$s$s)
        )+
      )
      \n+
    }{}x and push @s, {ul => $1} and next;

    # Regular paragraph:
    s/\A
      (
        (?:
          (?:$b|-1$s|\`x|\[[\w\#\"\*\`]|`[\(]|<http|[\w\"\(]|\`\w)
          .*\n
        )+
      )
      (?:
        (?= $code | : ) |
        \z |
        \n+
      )
    //x
      and push @s, {p => $1} and next;

    # Indented block:
    s{\A
      (
        > $s+ $line
        (?:
          \S $line
        )*
      )
      \n+
    }{}x and push @s, {indent => $1} and next;

    s{
      \A(
        (?: \[\^ .* \]\: $line )+
        \n+
      )
    }{}x
      and push @s, {footnote => $1} and next;

    s/\A(----\n)\n+//
      and push @s, {hr => $1} and next;

    s/\A((?s:```.+?\n```\n))\n+//
      and push @s, {pre => $1} and next;

    s/\A(!\[.*\.svg\)\n)\s+//
      and push @s, {img => $1} and next;

    s/\A(\* .*\n(?:  \S.*\n|\n(?=  \S))+)\n+//
      and push @s, {ul => $1} and next;

    s/\A((?:\| .*\n)+)\n+//
      and push @s, {table => $1} and next;

    s/\A($comment)\n*//
      and push @s, {comment => $1} and next;

    s/\A$ial// and next;

    s/\n+\z// and next;

    WWW(\@s);
    s/(${line}{20})$x*/$1/;
    die "*** ERROR ***\nParse failed at this point:\n$_\n*** EOF ***\n";
  }

  return \@s;
}

#------------------------------------------------------------------------------
sub fmt_html_block {
  s/\A<([a-z]+)(.*)>\n// or die;
  my $out = $_;
  my $tag = $1;
  my $more = $2;
  $more =~ s/^\s*(.*?)\s*$/$1/;
  my $id;
  my @class;
  my @attrs;
  if (not grep /^$tag$/, qw(div table blockquote)) {
    push @class, $tag;
    $tag = 'div';
  }
  while ($more) {
    $more =~ s/^\.([-a-z0-9]+)\s*// and push @class, $1 and next;
    $more =~ s/^\#([-a-z]+)\s*// and $id = $1 and next;
    ( $more =~ s/^([-a-z]+)=([-a-z0-9]+)\s*// or
      $more =~ s/^([-a-z]+)="([^"]*)"\s*//
    ) and do {
      my $attr = $1;
      my $val = $2;
      $attr = "data-$attr" unless
        $attr =~ /^(?:(?:id|class|style)$|data-)/;
      push @attrs, qq{$attr="$val"};
      next;
    };
    die "Parse html_block failed here: '$more'";
  }
  my $line = "<$tag";
  if ($id) {
    $line .= qq{ id="$id"};
  }
  if (@class) {
    $line .= qq< class="${\ join ' ', @class}">;
  }
  if (@attrs) {
    $line .= qq< ${\ join ' ', @attrs}>;
  }
  $line .= ">\n";
  $out =~ s{</\w+>\n+\z}{</$tag>};
  $_ = "$line$out";
}

sub fmt_heading {
  set_dates();
  set_heading_level();

  return unless /\d\.\s/;

  my $text = $_;
  my $slug = slugify($text);

  $_ = qq{<div id="$slug" />\n$text\n};
}

sub fmt_dt {
  set_dates();

  my $text = $_;
  my $slug = slugify($text);

  $_ = qq{<div id="$slug" />\n\n$text\n};
}

sub fmt_example {
  my ($title, $yaml1, $yaml2, $legend) = @$_;

  my $id = $title;
  $id =~ s/\s*\(.*//s;
  $id = slugify($id);

  my $out = set_example_level($title) . "\n\n";

  if ($legend) {
    $yaml1 = apply_highlights($yaml1, $legend);
  }
  else {
    if ($yaml1 =~ s/($comment+)\n*\z//) {
      $yaml1 = apply_highlights($yaml1, $1);
    }
  }
  $yaml1 = format_pre($yaml1);
  $yaml1 =~ s{_eof_}{<i>eof</i>}g;

  my $inner_markdown = 0;
  if ($yaml2) {
    if ($yaml2 =~ s/($comment+)\n*\z//) {
      $yaml2 = apply_highlights($yaml2, $1);
    }
    if ($yaml2 =~ /\A```\n(?:[\{\[]\ |"|!)/) {
      $yaml2 = format_pre_json($yaml2);
      $inner_markdown = 1;
    }
    else {
      $yaml2 = format_pre($yaml2);
    }
    if ($yaml2 =~ /ERROR:/) {
      $yaml1 =~ s/<pre(\ ?)/<pre class="error"$1/;
      $yaml2 =~ s/<pre(\ ?)/<pre class="error"$1/;
    }
    $out .= <<"...";
<table width="100%">
<tr>
<td class="side-by-side">
$yaml1
</td>
<td class="side-by-side" markdown="$inner_markdown">
$yaml2
</td>
</tr>
</table>
...
  }
  else {
    $yaml1 =~ s/<pre>/<pre class="example">/;
    $out .= "$yaml1\n";
  }

  if ($legend) {
    $_ = format_legend($legend);
    $out .= <<"...";
<div class="legend" markdown=1>
$_
</div>
...
  }

  chomp $out;

  $_ = <<"...";
<div id="$id" class="example">
$out
</div>
...
}

sub fmt_ul {
  format_links();
}

my $figure = 0;
sub fmt_p {
  set_dates();
  format_links();
  if (/^\*\*Figure #\./m) {
    my $chapter = $heading_level[0];
    $figure++;
    s/^\*\*Figure #\./**Figure $chapter.$figure./;
  }
}

sub fmt_dd {
  s/^:\n(\S)/: $1/ or die $_;
  format_links();
}

sub fmt_hr {}

sub fmt_indent {
  format_links();
}

my $num = 0;
sub fmt_pre {
  my $pre = format_pre($_);
  my $x = $pre;
  if ($pre =~ s/\b((?!production)[a-z]+-\S+)(\s+::=)/%%%/) {
    my $rule = $1;
    my $sep = $2;
    $num++;
    $pre =~ s/<pre>/<pre class="rule">[$num]/;
    $pre =~
      s{
        \ (
          [cs]-l\+
          .*?
        )
        (?=[\(\+\*\?]|\s|\z)
      }
      {' ' . rule_link($1)}gex;
    $pre =~
      s{
        \ (
          (?:[a-z]+)-
          .*?
        )
        (?=[\{\(\+\*\?]|\s|\z)
      }
      {' ' . rule_link($1)}gex;
    $pre =~ s/%%%/$rule$sep/;
    chomp $pre;
    $rule =~ s/\(.*//;
    $pre = <<"...";
<div id="rule-$rule" />
$pre
...
  }
  $_ = $pre;
}

sub fmt_comment {}

sub fmt_img {}

sub fmt_table {}

sub fmt_footnote {}

#------------------------------------------------------------------------------
sub read_files {
  my ($root, $markdown_file, $links_file) = @_;
  my ($front, $markdown, $links);

  $markdown = read_file($markdown_file);
  if ($markdown =~ s/\A---\n(.*?\n)---\n+//s) {
    $front = $1;
    if ($front) {
      if (my $source = YAML::PP::Load($front)->{source}) {
        $markdown = read_file("$root/$source");
      }
    }
  }

  if (not defined $front) {
    $front = <<"...";
layout: default
...
  }

  if ($links_file) {
    $links = YAML::PP::LoadFile($links_file);
  }
  else {
    $links = {};
  }

  $markdown .= "\n";
  $front = "---\n$front---\n";
  return ($front, $markdown, $links)
}

sub read_file {
  my ($file) = @_;
  open my $fh, '<:encoding(UTF-8)', $file;
  local $/;
  <$fh>;
}

sub set_vars {
  my ($d,$m,$y);
  ($_,$_,$_,$d,$m,$y) = localtime;
  $YYYY = 1900 + $y;
  $MM = sprintf "%02d", $m + 1;
  $DD = sprintf "%02d", $d;
}

sub make_link_index {
  my ($parsed, $overrides) = @_;
  for my $section (@$parsed) {
    my $pre = $section->{pre} or next;
    next unless $pre =~ /(.*?)\ +::=/;
    my $rule = $1;
    next if $rule =~ /^production/;
    $rule unless $rule =~ /^\w+[-+]\S+$/;
    $rule =~ s/\(.*//;
    $links->{$rule} = "rule-$rule";
  }
  for my $section (@$parsed) {
    my $from = $section->{heading};
    my $text = lc($from);
    chomp $text;
    $text =~ /^#+\s+.*#\.\s/ or next;
    $text =~ s/^#+\s+//;
    $text =~ s/^chapter\s+//;
    $text =~ s/^#\.\s+//;
    $text =~ s/[\"\*\`]//g;
    $links->{$text} = slugify($text);
  }
  for my $k (keys %$overrides) {
    my $v = $overrides->{$k} || [$k];
    for my $t (@$v) {
      $links->{$t} = $k;
    }
  }
  for my $k (keys %$overrides) {
    my $v = $overrides->{$k} || [$k];
    for my $t (@$v) {
      $links->{"${t}s"} ||= $k;
    }
  }
}

sub slugify {
  my ($slug) = @_;

  $slug =~ s/#+\s+Chapter\s\d+\.\s+//;
  $slug =~ s/^#+\s+(\d+\.)+//;
  $slug = lc $slug;
  $slug =~ s/[^a-z0-9]/-/g;
  $slug =~ s/-+/-/g;
  $slug =~ s/^-//;
  $slug =~ s/-$//;

  return $slug;
}

sub rule_link {
  my ($text) = @_;
  my $rule = $text;
  $rule =~ s/\(.*//;
  return qq{<a href="#rule-$rule">$text<\/a>};
}

sub format_links {
  s{
    \[ (?!\^)
      (
        (?![01]- | \d{3} )
        [^-\`\]]
        [^\]]*?
      )
    \]
    (?= [^\(\`] )
  }{format_internal_link($1)}gex;
}

sub format_internal_link {
  my ($link) = @_;
  my $text = lc($link);
  $text =~ s/\s+/ /g;
  $text =~ s/’/'/g;
  my $anchor;
  if ($text =~ /\*\*/) {
    return "$link";
  }
  if ($anchor = $links->{$text}) {
    return "[$link](#$anchor)";
  }
  if ($anchor = $links->{"${text}s"}) {
    return "[$link](#$anchor)";
  }
  if ($text =~ /^#(.*)/) {
    if ($anchor = $links->{$1}) {
      return "<sup class=\"rule-link\">[?](#$anchor)</sup>";
    }
    warn "\e[0;31m*** WARNING - Rule link '[$text]' is orphaned ***\e[0m\n";
    return "<sup class=\"orphan-rule-link\">[XXX](#$anchor)</sup>";
  }
  die "Undefined link '[$link]' ($text) found. Check links.yaml file.";
}

sub set_dates {
  s/YYYY(.)MM(.)DD/$YYYY$1$MM$2$DD/g;
  s/YYYY/$YYYY/g;
}

my $example_number;
sub set_heading_level {
  my $lvl = 1;
  if (/^#+\ .*((?:[\dA-Z]+\.)+ )/) {
    my @parts = split(/\./, $1);
    @heading_level = (@parts, 0, 0, 0);
  } else {
    my $txt = '';
    /^(#+)\ .*(#)\./ or return;
    $lvl = length $1;

    for (my $i = 0; $i < 4; $i++) {
      if ($i < $lvl) {
        if ($i == $lvl - 1) {
          $heading_level[$i]++;
        }
        $txt .= $heading_level[$i] . '.';
      }
      else {
        $heading_level[$i] = 0;
      }
    }
    s/#\./$txt/;
  }

  $example_number = 0 if $lvl == 1;
}

sub set_example_level {
  my ($title) = @_;
  my $chapter = $heading_level[0];
  $example_number++;
  $title =~ s/\#\./$chapter.$example_number/;
  return $title;
}

sub apply_highlights {
  my ($yaml, $highlights) = @_;
  my @lines = split /\n/, $highlights;
  my @rules;
  for my $line (@lines) {
    if ($line =~ /<!--/) {
      $line =~ s/.*<!--\s+(.*?)\s+-->/$1/;
      push @rules, [split /\s+/, $line];
    }
  }

  $yaml =~ s/\A```\n//;
  $yaml =~ s/\n```\n\z//;
  XXX $yaml if /(?:\[%|%\])/;

  @lines = split /\n/, $yaml;
  my @chars = map
    [ split //, $_ ],
    @lines;

  my $i = @rules + 1;
  for my $rule (reverse @rules) {
    $i--;
    for my $r (@$rule) {
      next unless $r =~ /^[1-9]/;
      $r =~ /^([1-9]\d*)(?::(\d+)(,\d*)?)?$/
        or XXX $r;
      my ($row, $col, $end) = ($1, $2, $3);
      my $len = @{$chars[--$row]} - 1;
      if ($col) {
        $col--;
        if ($end) {
          $end =~ s/^,// or die;
          if ($end eq '') { $end = $len }
          else { $end = $col + $end - 1 }
        }
        else { $end = $col }
      }
      else { $col = 0; $end = $len }
      $chars[$row]->[$col] =~ s{^}{[%mark class="legend-$i"%]};
      $chars[$row]->[$end] =~ s{$}{[%/mark%]};
    }
  }

  $yaml = join "\n",
    map { $_ = join '', @$_ }
    @chars;

  my $i = 0;
  for my $rule (@rules) {
    $i++;
    my @re;
    for my $r (@$rule) {
      next if $r =~ /^[1-9]/;
      $r =~ s/^0//;
      $r =~ s/([\"\'\!\*\+\?\|\{\}\[\]\(\)\.\\])/\\$1/g;
      $r =~ s/_/\\ /g;
      push @re, $r;
    }
    next unless @re;
    my $re = '(' . join('|', @re) . ')';
    $yaml =~ s{$re}{[%mark class="legend-$i"%]${1}[%/mark%]}g;
  }

  return $yaml;
}

sub format_pre {
  $_ = $_[0];
  s/\n+\z/\n/;

  s/\A```\n//;
  s/\n```\n*\z//;
  s/&/&amp;/g;
  s/</&lt;/g;
  s/>/&gt;/g;

  s/\[%/</g;
  s/%\]/>/g;

  return <<"...";
<pre>
$_
</pre>
...
}

sub format_pre_json {
  $_ = $_[0];
  s/\n+\z/\n/;
  s/\A```\n/```json\n/;
  return $_;
}

sub format_legend {
  $_ = $_[0];
  chomp;
  s/\s*<!--.*-->//g;
  my @lines = split /\n/, $_;
  my $i = 1;
  for (@lines) {
    if (/^\*\ /) {
      s{^\*\ (.*)}{* <code class="legend-$i">$1</code>}g;
      $i++;
    }
  }
  $_ = join "\n", @lines;
  s{\[([^\]]+)\]}{rule_link($1)}ge;
  return $_;
}

main @ARGV;
