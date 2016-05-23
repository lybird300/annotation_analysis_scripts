#!/usr/bin/perl
use strict;
use warnings;

# This checks to see if the indels annotated as substitution by IndelMapper 
# are also annotated by SnpMapper.

my $snps = $ARGV[0];
my $sub_indels = $ARGV[1];
open(my $fh_snp, '<', $snps) or die "Can't open $snps $!\n";
open(my $fh_sub_indels, '<', $sub_indels) or die "Can't open $sub_indels $!\n";

my %snps;
while(<$fh_snp>) {
  chomp $_;
  next if $_ =~ "^Position";
  # Not sure if this will cause problems if there are >1 $id or $ann
  my ($pos, $id, $ann) = split('\t', $_);
  # if >1 transcript IDs
  if ($id =~ /;/) {
    my @ids = split(';', $id);
    push (@{$snps{$pos}{'transcript'}}, @ids);
  }
  else {
    push (@{$snps{$pos}{'transcript'}}, $id);
  }
  if ($id =~ /;/) {
    my @annos = split(';', $ann);
    push (@{$snps{$pos}{'effect'}}, @annos);
  }
  else {
    push (@{$snps{$pos}{'effect'}}, $ann);
  }
}

while(<$fh_sub_indels>) {
  chomp $_;
  next if $_ =~ "^Position";
  my ($pos, $id, $ann) = split('\t', $_);
  if (exists $snps{$pos}) {
    next;
    #my $snp_ids = join (';', @{$snps{$pos}{'transcript'}});
    #print "$pos\t$id\t$ann\t\t$snp_ids\t@{$snps{$pos}{'effect'}}\n";
  } 
  else {
    print "$pos is not in SNP file\n";
  }
}
close $fh_snp;
close $fh_sub_indels;
