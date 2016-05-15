#!/usr/bin/perl
use strict;
use warnings;
use Scalar::MoreUtils qw(empty);

# This script checks the biomart text file to see if
# there are any transcripts that map to my ensembl IDs.
# I wrote this because sometimes there are very few IDs
# that mapped and I have thousands of ensembl IDs, but
# I don't want to scroll through the whole file to find them.

my $file = shift;
open(my $fh, '<', $file) or die "Can't open $file $!\n";

while(<$fh>) {
  chomp $_;
  next if $_ =~ "^Ensembl";
  my ($enst, $ref1, $ref2) = split('\t', $_);
  if (not empty $ref1) {
    print "$_\n";
  }
  if (not empty $ref2) {
    print "$_\n";
  }
}
