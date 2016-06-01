#!/usr/bin/perl
use strict;
use warnings;

# Get all positions where there is more than 1 effect term and print
# position and all terms.
my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file $!\n";

my %variants;
my %unique;

while(<$fh>) {
  chomp $_;
  next if $_ =~ "^id";
  my @cols = split "\t", $_;
  my $pos = $cols[1].":".$cols[2].":".$cols[3];
  push (@{$variants{$pos}{$cols[5]}}, $cols[6]);  
}

# Iterate through hash to find positions where there are more than 1 effect
foreach my $pos (keys %variants) {
  my @effects = (keys %{$variants{$pos}});
  if (scalar @effects > 1) {
    #my ($chr, $start, $end) = split ":", $pos;
    my $effects = join ";", @effects;
    $unique{$effects}++;
    #print "$chr\t$start\t$end\t$effects\n";
  }
}

my @unique_effects = keys %unique;
foreach (@unique_effects) {
  print "$_\n";
}
close $fh;
