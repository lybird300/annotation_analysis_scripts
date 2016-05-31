#!/usr/bin/perl
use strict;
use warnings;
use List::UtilsBy qw(min_by);

# Reduce SnpEff effects to 1 per line
my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file. $!";

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
  '3_prime_UTR_truncation'                         => 24,
  '5_prime_UTR_variant'                            => 25,
  '3_prime_UTR_variant'                            => 25,
  'non_coding_transcript_exon_variant'             => 26,
  'conserved_intron_variant'                       => 27,
  'intron_variant'                                 => 28,
  'intragenic_variant'                             => 29,
  'transcript_variant'                             => 30,
  'gene_variant'                                   => 31,
  'non_coding_transcript_variant'                  => 32,
  'upstream_gene_variant'                          => 33,
  'downstream_gene_variant'                        => 33,
  'regulatory_region_variant'                      => 34,
  'conserved_intergenic_variant'                   => 35,
  'intergenic_variant'                             => 36,
);

=cut

# Ranking is based on snpeff documentation
# Need to check these before using
my %terms = (
  'chromosome_structure_variation'                 => 1,
  'exon_loss_variant'                              => 2,
  'frameshift_variant'                             => 3,
  'stop_gained'                                    => 4,
  'stop_lost'                                      => 5,
  'start_lost'                                     => 6,
  'splice_acceptor_variant'                        => 7,
  'splice_donor_variant'                           => 7,
  'rare_amino_acid_variant'                        => 8,
  'missense_variant'                               => 9,
  'inframe_insertion'                              => 10,
  'disruptive_inframe_insertion'                   => 11,
  'inframe_deletion'                               => 12,
  'disruptive_inframe_deletion'                    => 13,
  '5_prime_UTR_truncation'                         => 14,
  '3_prime_UTR_truncation'                         => 15,
  'splice_region_variant'                          => 16,
  'stop_retained_variant'                          => 17,
  'start_retained_variant'                         => 18,
  'initiator_codon_variant'                        => 20,
  'synonymous_variant'                             => 21,
  'coding_sequence_variant'                        => 22,
  'exon_variant'                                   => 23,
  '5_prime_UTR_variant'                            => 24,
  '3_prime_UTR_variant'                            => 24,
  '5_prime_UTR_premature_start_codon_gain_variant' => 25,
  'non_coding_transcript_exon_variant'             => 26,
  'upstream_gene_variant'                          => 27,
  'downstream_gene_variant'                        => 28,
  'regulatory_region_variant'                      => 29,
  'mature_miRNA_variant'                           => 30,
  'non_coding_transcript_variant'                  => 31,
  'conserved_intron_variant'                       => 32,
  'intron_variant'                                 => 33,
  'intragenic_variant'                             => 34,
  'conserved_intergenic_variant'                   => 35,
  'intergenic_variant'                             => 36,
  'transcript_variant'                             => 37,
  'gene_variant'                                   => 38,
);

=cut

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
