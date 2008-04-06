#!/usr/bin/perl -w

use strict;

my $lino = 0;
my $production = 0;
my $bad_productions = 0;
while (my $line = <>) {
  $lino++;
  if ($line =~ /<production id="(.*)"/) {
    $production = $1;
    next;
  }
  if ($line =~ /<lhs>(.*)<\/lhs>/) {
    my $lhs = $1;
    next if ($lhs eq $production);
    warn "Line $lino: Production $production != lhs $lhs\n";
    $bad_productions++;
  }
}

die("There were production/lhs mismatches\n") if ($bad_productions > 0);
