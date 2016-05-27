#!/usr/bin/perl
use strict;
use warnings;

# Reduce VAT effects to the one with the most impact
my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file. $!";

my %terms = (
  'synonymous_variant;missense_variant' => 'missense_variant',
  'frameshift_variant;structural_variant' => 'frameshift_variant',
  'inframe_deletion;structural_variant' => 'inframe_deletion',
  'synonymous_variant;stop_gained' => 'stop_gained',
  'splice_site_variant;missense_variant' => 'missense_variant',
  'synonymous_variant;stop_lost' => 'stop_lost',
  'synonymous_variant;splice_site_variant' => 'splice_site_variant',
  'missense_variant;stop_gained' => 'stop_gained',
  'stop_lost;missense_variant' => 'stop_lost',
  'splice_site_variant;structural_variant' => 'splice_site_variant',
  'splice_site_variant;frameshift_variant;structural_variant' => 'frameshift_variant',
  'synonymous_variant;missense_variant;stop_gained' => 'stop_gained',
  'initiator_codon_variant;structural_variant' => 'initiator_codon_variant',
  'frameshift_variant;inframe_insertion' => 'frameshift_variant',
);

while (<$fh>) {
  chomp $_;
  my ($chr, $start, $end, $ids, $ann, $tool) = split('\t', $_);
  if (($ann eq '.') || ($ann !~ /;/)) {
    print "$_\n";
    next;
  }
  else {
    if (exists $terms{$ann}) {
      $ann = $terms{$ann};
      print "$chr\t$start\t$end\t$ids\t$ann\t$tool\n";
    }
    else {
      print "Can't map term $ann\n";
    }
  } 
}
close $fh;
