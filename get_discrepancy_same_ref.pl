#!/usr/bin/perl
use strict;
use warnings;

my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file $!\n";

my %variants;
my %unique;

while(<$fh>) {
  chomp $_;
  next if $_ =~ "^id";
  my @cols = split "\t", $_;
  if (($cols[6] eq 'ANNOVAR') || 
      ($cols[6] eq 'snpEff') || 
      ($cols[6] eq 'VAAST')) {
    my $pos = $cols[1].":".$cols[2].":".$cols[3];
    push (@{$variants{$pos}{$cols[5]}}, $cols[6]); 
  } 
}

foreach my $pos (keys %variants) {
  my @effects = (keys %{$variants{$pos}});
  if (scalar @effects > 1) {
    my $effects = join ";", @effects;
    $unique{$effects}++;
  }
}

foreach my $effect (keys %unique) {
  print "$effect\t$unique{$effect}\n";
}
close $fh;
