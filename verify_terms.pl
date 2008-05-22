#!/usr/bin/perl -w

use strict;
use XML::Parser;
use YAML;

my @parts_stack = ();
my %def_terms = ();
my %ref_terms = ();
my %ref_def_terms = ();
my %def_ref_terms = ();
my %ok_def_ref_terms = (
    '<term primary="\\ escaping in double-quoted style">'
  . ' @ Characters / Escape Sequences' => 1
);

my $keep_next_title = 0;
my $keep_next_text = 0;

sub PI {
}

my $in_non_term = 0;

sub StartTag {
  my $tag = $_;
  my $attr = \%_;

  if ($tag =~ /<nonterminal def="#(.[^("]*)/) {
    $in_non_term = $1;
    $in_non_term =~ s/\+/\\+/g;
    $in_non_term = 0 if $in_non_term eq 'c-reserved';
  }

  if ($tag =~ /^<sect|^<chapter|^<book>/) {
    die if ($keep_next_title++);
    return;
  }

  if ($tag =~ /^<title/ && $keep_next_title) {
    $keep_next_title--;
    die if ($keep_next_text++);
    return;
  }


  if ($tag =~ /^<defterm/) {
    $tag =~ s/(?:\s|\n)+/ /g;
    $tag =~ s/defterm/term/g;
    my $path = join(' / ', @parts_stack);
    $def_terms{$tag} = $path;
    warn "REF-DEF $tag in $path\n" if (defined($ref_terms{$tag}->{$path})
                                    && !$ref_def_terms{$tag}++);
    return;
  }

  if ($tag =~ /^<refterm/) {
    $tag =~ s/(?:\s|\n)+/ /g;
    $tag =~ s/refterm/term/g;
    my $path = join(' / ', @parts_stack);
    $ref_terms{$tag} = {} unless defined($ref_terms{$tag});
    $ref_terms{$tag}->{$path} = 1;
    warn "DEF-REF $tag in $path\n" if (defined($def_terms{$tag})
                                   && $def_terms{$tag} eq $path
                                   && !$ok_def_ref_terms{"$tag @ $path"}
                                   && !$def_ref_terms{$tag}++);
    return;
  }
}

sub Text {
  my $text = $_;
  warn("PRD-REF $text => $in_non_term") if $in_non_term and $text !~ /^.$|^${in_non_term}/;
  if ($keep_next_text) {
    $text =~ s/(?:\s|\n)+/ /g;
    push(@parts_stack, $text);
    $keep_next_text--;
  }
}

sub EndTag {
  my $tag = $_;
  my $attr = \%_;
  $in_non_term = 0 if ($tag =~ /nonterminal/);

  pop(@parts_stack) if ($tag =~ /sect|chapter|book/);
}

my $parser = new XML::Parser(Style => 'Stream');
$parser->parsefile('spec.dbk');
die "THERE WERE REF-DEF TERMS - HTML index will not highlight main entry!\n"
    if (keys(%ref_def_terms));
die "THERE WERE DEF-REF TERMS - referals to same-section main entry.\n"
    if (keys(%def_ref_terms));
1;
