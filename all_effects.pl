#!/usr/bin/perl
use strict;
use warnings;

my $file = shift;
open(my $fh, '<', $file) or die "Can't open $file:$!\n";

while (my $line = <$fh>) {
  chomp $line;
  if ($line =~ "^Position") {
    next;
  }
  my @cols = split('\t', $line);
  my @effect = split(';', $cols[2]);
  foreach (@effect) {
    print "$_\n";
  }
}
close $fh;
