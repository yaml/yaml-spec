#!/usr/bin/perl -w

use strict;
use English;

my $table_depth = 0;
my $simple_table_depth = -1;
my $text = "";
while (my $line = <>) {
  next if $line =~ /logo.png/;
  $line =~ s/\n// if ($line =~ /class="database"/);
  $line =~ s/span class="index"/span class="appendix"/g;
  $line =~ s/width="3%"/class="productioncounter"/g;
  $line =~ s/width="10%"/class="productionlhs"/g;
  $line =~ s/width="5%"/class="productionseperator"/g;
  $line =~ s/width="52%"/class="productionrhs"/g;
  $line =~ s/width="30%"/class="productioncomment"/g;
  $line =~ s/Symbols/Indicators/g;
  $line =~ s/<table border="1">/<table border="0" style="width: 0%">/g;
  $line =~ s/em>/b>/g if $line =~ /<em>(Byte|Encoding)/;

  $table_depth++ if $line =~ /<table/;
  $simple_table_depth = $table_depth if $line =~ /<table.*class="simplelist"/;
  $table_depth-- if $line =~ /<\/table/;
  $line =~ s/<td>/<td width="50%">/ if $table_depth == $simple_table_depth;

  # Collapse spaces in such link ids.
  for (my $i = 0; $i < 6; $i++) {
    $line =~ s/id="((?:[^" ]+ )+ )[ ]+/id="$1/;
  }
  $text .= $line;
}

# Make defterm a link to the index entry for unquoted terms.
$text =~ s:</i>::g;
$text =~ s: <a \s id=" ([^/]*) / ([^"]*) ">
            </a>
            <i \s class="firstterm">
            ([^]*.)
            
          :<a id="$1/$2"></a
            ><a href="#index-entry-$1"
            ><i class="firstterm"
            >$3</i></a
          >:gx;

print $text;
