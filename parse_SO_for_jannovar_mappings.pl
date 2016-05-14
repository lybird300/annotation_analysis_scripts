#!/usr/bin/perl
use strict;
use warnings;

# I used this script to parse out Jannovar mappings from output 
# of using awk to print all lines from SO file with Jannovar mappings

# awk '$2 ~ "Jannovar" {print $0}' revised-so-xp.obo > output.txt

my $file = shift;
open (FH, $file) or die "Can't open $file:$!\n";

while (my $line = <FH>) {
  chomp $line;
  if ($line =~ /"([\w:_]*)/g) {
    print "$1\n";
  }
}
close FH;
