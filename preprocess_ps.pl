#!/usr/bin/perl -w

use strict;
use English;

my $in_mark = 0;
my $text = "";
while (my $line = <>) {
    # Change hl2 (dotted) to larger, more sparse dots
    $line =~ s/\[0.5 0.5\] 0.0 setdash/[1 2] 0.0 setdash/g;
    # Change hl4 to dot-dashed.
    $line =~ s/\[0.499 0.499\] 0.0 setdash/[3.0 2.0 0.5 1.5] 0.0 setdash/g;
    # Change all line widths to 0.6 for consistency
    $line =~ s/[0-9.]* setlinewidth/0.5 setlinewidth/g;
    # Remove the RenderX watermark
    $in_mark = 1 if $line =~ /\(XSL\)/;
    $in_mark = 0 if $line =~ /\(FO\)/;
    $line =~ s/\(XSL\) show//g;
    $line =~ s/\(\xb7\) show//g if $in_mark;
    $line =~ s/\(FO\) show//g;
    $line =~ s/\(RenderX\) show//g;

    print $line;
}
