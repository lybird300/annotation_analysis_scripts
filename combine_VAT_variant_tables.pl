#!/usr/bin/perl
use strict;
use warnings;

# Combines processed VAT files into 1 variant table file

my @files = qw(mapped_vat_snp_variants.txt mapped_vat_indel_variants.txt mapped_vat_SV_variants.txt);

my %vat;

foreach (@files) {
  open (my $fh, '<', $_) or die "Can't open $_ $!\n";
  while(<$fh>) {
    chomp $_;
    my ($pos, $id, $ann) = split('\t', $_);
    if ($id ne '.') {
      my @ids = split(';', $id);
      push @{$vat{$pos}{'transcript'}}, @ids;
    }
    if ($ann ne '.') {
      my @annos = split(';', $ann);
      push @{$vat{$pos}{'effect'}}, @annos;
    }  
  }
  close $fh;
}

foreach my $position (keys %vat) {
  my $ids = join(';', @{$vat{$position}{'transcript'}});
  my $effects = join(';', @{$vat{$position}{'effect'}});
  print "$position\t$ids\t$effects\n";
}
