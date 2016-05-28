#!/usr/bin/perl
use strict;
use warnings;
use List::UtilsBy qw(min_by);

# Reduce Seattleseq effects to 1 per line
my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file. $!";

my %terms = (
  'splice_acceptor_variant'                     => 1,
  'splice_donor_variant'                        => 1,
  'stop_gained'                                 => 2,
  'frameshift_variant'                          => 3,
  'stop_lost'                                   => 4,
  'exonic_splice_region_variant'                => 5,
  'complex_transcript_variant'                  => 6,
  'missense_variant'                            => 7,
  'synonymous_variant'                          => 8,
  'coding_sequence_variant'                     => 9,
  '5_prime_UTR_variant'                         => 10,
  '3_prime_UTR_variant'                         => 10,
  'non_coding_transcript_exon_variant'          => 11,
  'intron_variant'                              => 12,
  '5KB_upstream_variant'                        => 13,
  '5KB_downstream_variant'                      => 14,
  'intergenic_variant'                          => 15,
  'incomplete_transcript_coding_splice_variant' => 16,
  'incomplete_transcript_CDS'                   => 17,
);

while (<$fh>) {
  chomp $_;
  my ($chr, $start, $end, $ids, $terms, $tool) = split('\t', $_);
  if (($terms eq '.') || ($terms !~ /;/)) {
    print "$_\n";
    next;
  }
  else {
    my @effects = split(';', $terms);
    my %comparison;
    foreach (@effects) {
      if (exists $terms{$_}) {
        $comparison{$_} = $terms{$_};
      } 
    }
    my @values = values(%comparison);
    my @sorted_values = sort { $b <=> $a } @values;
    if ($sorted_values[0] == $sorted_values[1]) {
      my @lowest_terms;
      foreach my $key (keys %comparison) {
        if ($comparison{$key} == $sorted_values[0]) {
          push (@lowest_terms, $key); 
        }
      }
      my $trim_terms = join ';', @lowest_terms;
      print "$chr\t$start\t$end\t$ids\t$trim_terms\t$tool\n";
    } 
    else {
      my $highest = min_by { $comparison{$_} } keys %comparison;
      print "$chr\t$start\t$end\t$ids\t$highest\t$tool\n";
    }
  }
}
close $fh;
