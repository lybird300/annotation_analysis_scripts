#!/usr/bin/perl
use strict;
use warnings;

=cut

my $snps = 'mapped_vat_snp_variants.txt';
my $SVs = 'mapped_vat_SV_variants.txt';
my $indels = 'mapped_vat_indel_variants_substitution_removed.txt';
open (my $fh_snp, '<', $snps) or die "Can't open $snps $!\n";
open (my $fh_SV, '<', $SVs) or die "Can't open $SVs $!\n";
open (my $fh_indel, '<', $indels) or die "Can't open $indels $!\n";

=cut

my @files = qw(mapped_vat_snp_variants.txt mapped_vat_indel_variants_substitution_removed.txt mapped_vat_SV_variants.txt);

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
