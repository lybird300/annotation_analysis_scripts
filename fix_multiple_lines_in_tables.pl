#!/usr/bin/perl
use strict;
use warnings;

# This script fixes multiple instances of a genomic position in 
# the variant table. I want one line per position with all of the 
# transcript IDs and effects included.

my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file:$!\n";

my %positions;

while (<$fh>) {
  chomp $_;
  if ($_ =~ "^Position") {
    next;
  }
  my @cols = split('\t', $_);
  my $pos = $cols[0];

  # You have to actually split these and add them to the hash
  # If not, you will lose data
  my @all_ids = split(';', $cols[1]);
  foreach (@all_ids) {
    if ($_ ne '.') { 
      push (@{$positions{$pos}{'ids'}}, $_); 
    }
  }
  
  my @all_effects = split(';', $cols[2]);
  foreach (@all_effects) {
    if ($_ ne '.') {
      push (@{$positions{$pos}{'effects'}}, $_);
    }
  }
} 

foreach my $key (sort keys %positions) {
  my %ids = map {$_ => 1} @{$positions{$key}{'ids'}};
  my @ids = keys %ids;
  my %effects = map {$_ => 1} @{$positions{$key}{'effects'}};
  my @effects = keys %effects;
  my $ids = join(';', @ids);
  my $effects = join(';', @effects);
  print "$key\t$ids\t$effects\n";
}
close $fh;
