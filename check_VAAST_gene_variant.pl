#!/usr/bin/perl
use strict;
use warnings;

# I wrote this script to check the kinds of transcript IDs attached
# to gene_variant annotations output from VAAST. I don't want to 
# include gene symbols in my table of annotations.

my $file = shift;
open (FH, '<', $file) or die "Can't open $file:$!\n";

while (my $line = <FH>) {
  chomp $line;
  if ($line =~ '^#') {
    next;
  }
  my ($chr, $source, $type, $start, $end, $score, $strand, 
      $phase, $attributes) = split(/\t/, $line);
  my @attributes = split(';', $attributes);
  foreach my $a (@attributes) {
    if ($a =~ /gene_variant\s\d\s\w*\s([\w\d]*)/) {
      print "$1\n";
    }
  }
}
close FH;
