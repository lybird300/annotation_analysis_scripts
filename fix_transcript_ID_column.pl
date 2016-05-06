#!/usr/bin/perl
use strict;
use warnings;

# This script fixes the transcript ID columns of VAT variant tables
# that have sequence features in them.

my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file $!";

while (my $line = <$fh>) {
  chomp $line;
  if ($line =~ '^Position') {
    print "$line\n";
  }
  else {
  my @cols = split(/\t/, $line);
  if ($cols[1] !~ '^E') {


    # mRNA;ENST00000008180.9
    $cols[1] =~ s/mRNA;(E.*)/$1/;


    # I have to run this separately for each regex to fix everything 
    # in the file.
    # mRNAENST00000008180.9
    #$cols[1] =~ s/mRNA(E.*)/$1/;
    # ;sequence_feature;ENST00000371330.1
    # ;ENST00000543923.1;sequence_feature 
    #$cols[1] =~ s/(;sequence_feature)?;(E[a-zA-Z0-9.]*)(;sequence_feature)?/$2/;
    $line = $cols[0]."\t".$cols[1]."\t".$cols[2]; 
  }
  print "$line\n";
  }
}
close $fh;
