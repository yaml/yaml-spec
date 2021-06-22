use v5.18;
package MarkdownParser;

my $re_pre = qr/
  ```\n
  (?:.*\n)+?
  ```\n
/x;
my $re_legend = qr/
  \*\*Legend:\*\*\n
  (?:\*\ .*\n)+
/x;

sub parse_sections {
  ($_) = @_;

  my @s;
  while ($_) {
    # Skip blank lines:
    s/\A\n+// and next;

    # Headings:
    s/\A(\S.*\n)===+\n\n+//
      and push @s, {heading => "# $1"} and next;

    s/\A(#{1,5} .*\n)\n+//
      and push @s, {heading => $1} and next;

    # Example section:
    s/\A
      (\*\*Example\ \# [\s\S]*?\*\*)\n
      ($re_pre)
      ($re_pre)?
      ($re_legend)?
      \n+
    //x
      and push @s, {example => [$1, $2, $3, $4]} and next;

    # Lists:
    s/\A
      (
        (::.*\n)?
        (?: (?:\*|\d+\.) \ \S.*\n)
        (?:
          \n?
          (?:
            (?: \ * (?:\*|\d+\.) \ \S.*\n) |
            (?: \ + \S.*\n) |
          )
        )*
        (?:\{:\.\S+\}\n)?
      )
      \n+
    //x
      and push @s, {ul => $1} and next;

    # Paragraphs
    s/\A
      (
        (?:
          (?:
            \*\* |
            -1\  |
            \[ [\w\"\*] |
            [\w\"\(\`]
          )
          .*\n
        )+
      )
      (?:
        (?=```|\*\ ) |
        \z |
        \n+
      )
    //x
      and push @s, {p => $1} and next;

    s/\A(----\n)\n+//
      and push @s, {hr => $1} and next;

    s/\A\::toc\n\n+//
      and push @s, {toc => 1} and next;

    s/\A\::index\n//
      and push @s, {index => 1} and next;

    s/\A((?:>.*\n)+)\n+//
      and push @s, {indent => $1} and next;

    s/\A((?s:```.+?\n```\n))\n+//
      and push @s, {pre => $1} and next;

    s/\A(!\[.*\.png\)\n)\s+//
      and push @s, {img => $1} and next;

    s/\A(\* .*\n(?:  \S.*\n|\n(?=  \S))+)\n+//
      and push @s, {ul => $1} and next;

    s/\A(\`\w.*\n)\n+//
      and push @s, {p => $1} and next;

    s/\A((?:\| .*\n)+)\n+//
      and push @s, {table => $1} and next;

    s/\A((?:\* .*\n)(?:  .*\n|\n(?=  ))+)\n+//
      and push @s, {ul => $1} and next;

    s/\A(<!--(?:.*\n)+?-->\n)\n*//
      and push @s, {comment => $1} and next;

    s/((?:.*\n){20})(?s:.*)/$1/;
    require XXX;
    XXX::WWW(\@s);
    die "*** ERROR ***\nMarkdownParser failed at this point:\n$_\n*** EOF ***\n";
  }

  return \@s;
}

1;
