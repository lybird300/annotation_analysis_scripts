#!/usr/bin/perl
use strict;
use warnings;

# This is to sort chr X variants from table file after concatenating
# duplicate lines with fix_multiple_lines_in_table.pl.
# TODO: Figure out how to sort on chromosome number and then on chr X or Y

my $file = shift;
my $cmd = "grep -v '^Position' $file | sort -t: -k 1,1n -k 2,2n -k 3,3n";
system("$cmd") == 0 or die "Error running $cmd\n";
