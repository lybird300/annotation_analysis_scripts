#!/usr/bin/perl
use strict;
use warnings;

# This script compares compares chr:start:end for each tool.
# I make files for each tool with their chr:start:end and then
# use diff to compare them.

my @files = @ARGV;
my $prefix = 'position';
foreach (@files) {
  my $cmd = "awk '{print \$1}' $_ > $prefix.$_";
  system($cmd) == 0 or die "Error running $cmd\n";
}
my $position_files = `ls position*`;
my ($file1, $file2) = split('\n', $position_files);
#throws an error here but still runs
my $cmd = "diff -u $file1 $file2 > $file1.$file2.diff";
system($cmd) == 0 or die "Error running $cmd\n"; 
