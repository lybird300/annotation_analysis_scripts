#!/usr/bin/perl
use strict;
use warnings;

# Count the number of variant lines in multiple variant table files
# Faster than running this each time on the command line for each file
# Example usage:
# perl ../annotation_analysis_scripts/count_variants.pl *_chr19.txt

my @files = @ARGV;
foreach (@files) {
  my $cmd = "grep -v '^Position' $_ | wc -l";
  print "$_ : ";
  system($cmd) == 0 or die "Error running $cmd\n";
}
