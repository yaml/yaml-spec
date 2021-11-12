#!/usr/bin/env perl

use v5.18;
use Encode;

use YAML::PP;
use XXX;

sub main {
  my ($front, $markdown, $link_map) = read_files(@_);

  my $parsed = parse_sections($markdown);

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
    s<\A(
      (${b}Example$s\# $x*?$b)\n+
      ($re_pre)
      ($re_pre)?
      ($re_legend)?
      \n+
    )><>x
      # and push @s, {example => [$1, $2, $3, $4]} and next;
      and push @s, {example => $1} and next;

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

sub fmt_heading {}

sub fmt_dt {}

sub fmt_example {}

sub fmt_ul {}

sub fmt_p {}

sub fmt_dd {
  s/^:\n(\S)/: $1/ or die $_;
}

sub fmt_hr {}

sub fmt_indent {}

sub fmt_pre {
  my $pre = format_pre($_);
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

main @ARGV;
