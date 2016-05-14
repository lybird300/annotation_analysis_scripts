#!/usr/bin/perl
use strict;
use warnings;

my $chr = shift;
my @files = `ls *.txt`;
foreach (@files) {
  chomp $_;
  my $cmd = "grep -v '^Position' $_ | grep '^$chr:' > chr_$chr/$_'\_'$chr.txt";
  system($cmd) == 0 or die "Error running $cmd\n";
}
