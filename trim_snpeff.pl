#!/usr/bin/perl
use strict;
use warnings;
use List::UtilsBy qw(min_by);

# Reduce SnpEff effects to 1 per line
my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file. $!";

=cut

# My rankings based on VEP documentation
my %terms = (
  'chromosome_structure_variation'                 => 1,
  'exon_loss_variant'                              => 2,
  'splice_acceptor_variant'                        => 3,
  'splice_donor_variant'                           => 4,
  'stop_gained'                                    => 5,
  'frameshift_variant'                             => 6,
  'stop_lost'                                      => 7,
  'start_lost'                                     => 8,
  'rare_amino_acid_variant'                        => 9,
  'disruptive_inframe_insertion'                   => 10,
  'inframe_insertion'                              => 11,
  'disruptive_inframe_deletion'                    => 12,
  'inframe_deletion'                               => 13,
  'missense_variant'                               => 14,
  'splice_region_variant'                          => 15,
  'stop_retained_variant'                          => 16,
  'start_retained_variant'                         => 17,
  'initiator_codon_variant'                        => 18,
  'synonymous_variant'                             => 19,
  'coding_sequence_variant'                        => 20,
  'exon_variant'                                   => 21,
  'mature_miRNA_variant'                           => 22,
  '5_prime_UTR_premature_start_codon_gain_variant' => 23,
  '5_prime_UTR_truncation'                         => 24,
  '3_prime_UTR_truncation'                         => 25,
  '5_prime_UTR_variant'                            => 26,
  '3_prime_UTR_variant'                            => 27,
  'non_coding_transcript_exon_variant'             => 28,
  'conserved_intron_variant'                       => 29,
  'intron_variant'                                 => 30,
  'intragenic_variant'                             => 31,
  'transcript_variant'                             => 32,
  'gene_variant'                                   => 33,
  'non_coding_transcript_variant'                  => 34,
  'upstream_gene_variant'                          => 35,
  'downstream_gene_variant'                        => 36,
  'regulatory_region_variant'                      => 37,
  'conserved_intergenic_variant'                   => 38,
  'intergenic_variant'                             => 39,
);

=cut

# Ranking is based on snpeff documentation
my %terms = (
  'chromosome_structure_variation'                 => 1,
  'exon_loss_variant'                              => 2,
  'frameshift_variant'                             => 3,
  'stop_gained'                                    => 4,
  'stop_lost'                                      => 5,
  'start_lost'                                     => 6,
  'splice_acceptor_variant'                        => 7,
  'splice_donor_variant'                           => 8,
  'rare_amino_acid_variant'                        => 9,
  'missense_variant'                               => 10,
  'inframe_insertion'                              => 11,
  'disruptive_inframe_insertion'                   => 12,
  'inframe_deletion'                               => 13,
  'disruptive_inframe_deletion'                    => 14,
  '5_prime_UTR_truncation'                         => 15,
  '3_prime_UTR_truncation'                         => 16,
  'splice_region_variant'                          => 17,
  'stop_retained_variant'                          => 18,
  'start_retained_variant'                         => 19,
  'initiator_codon_variant'                        => 20,
  'synonymous_variant'                             => 21,
  'coding_sequence_variant'                        => 22,
  'exon_variant'                                   => 23,
  '5_prime_UTR_variant'                            => 24,
  '3_prime_UTR_variant'                            => 25,
  '5_prime_UTR_premature_start_codon_gain_variant' => 26,
  'non_coding_transcript_exon_variant'             => 27,
  'upstream_gene_variant'                          => 28,
  'downstream_gene_variant'                        => 29,
  'regulatory_region_variant'                      => 30,
  'mature_miRNA_variant'                           => 31,
  'non_coding_transcript_variant'                  => 32,
  'conserved_intron_variant'                       => 33,
  'intron_variant'                                 => 34,
  'intragenic_variant'                             => 35,
  'conserved_intergenic_variant'                   => 36,
  'intergenic_variant'                             => 37,
  'transcript_variant'                             => 38,
  'gene_variant'                                   => 39,
);

while (<$fh>) {
  chomp $_;
  my ($chr, $start, $end, $ids, $terms, $tool) = split('\t', $_);
  # what if there is something like splice_region_variant&intron_variant and
  # no other terms? will it be caught?
  if (($terms eq '.') || ($terms !~ /[;\&]/)) {
    print "$_\n";
    next;
  }
  else {
    my @effects = split /[;\&]/, $terms;
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
