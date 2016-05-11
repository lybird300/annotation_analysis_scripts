#!/usr/bin/perl
use strict;
use warnings;

# This is to sort the variant table file after concatenating
# duplicate lines with fix_multiple_lines_in_table.pl.

my $file = $ARGV[0];
my $tool = $ARGV[1];
print "Position\tTranscript_ID\t$tool\n";
my $cmd = "grep -v '^Position' $file | sort -t: -k 1,1n -k 2,2n -k 3,3n";

system("$cmd") == 0 or die "Error running $cmd\n";
