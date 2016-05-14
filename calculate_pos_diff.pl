#!/usr/bin/perl
use strict;
use warnings;
use Path::Tiny qw(path);

# I want to calculate the difference in start and end positions
# for those lines that do not match. I'm wondering if it's the 
# coordinates that are different, but the variants are the same.

my $filename = shift or die "Usage: $0 FILENAME";

my @content = path($filename)->lines_utf8;

while (@content) {
# Iterate through file, pulling out 2 lines at a time
# Shift 2 lines at a time off of array to compare
my $line1 = shift @content;
my $line2 = shift @content;

# columns are separated by 1 space 
# when join outputs these lines, the tabs are lost 
my @line1_cols = split(/\s/, $line1);
my @line2_cols = split(/\s/, $line2);

my ($chr1, $start1, $end1) = split(':', $line1_cols[0]);
my ($chr2, $start2, $end2) = split(':', $line2_cols[0]);

my $start_diff = $start2-$start1;
my $end_diff = $end2-$end1;
print "$line1_cols[0]\t$line2_cols[0]\tStart_Difference: $start_diff\t".
      "End_Difference: $end_diff\n";
}
 
