#!/usr/bin/perl
use strict;
use warnings;
use List::UtilsBy qw(max_by);

# 1. I want to remove amino_acid_substitution from VAAST column
#    amino_acid_substitution has other terms around it for all cases
#    when it appears in the file.
# 2. I want to reduce the number of effects listed only to the most
#    specific in the VAAST column.
# I'm reducing effects not taking transcripts into account.

my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file. $!";

my %terms = (
  'sequence_variant'        => 1,
  'gene_variant'            => 2,
  'transcript_variant'      => 3,
  'exon_variant'            => 4,
  'intron_variant'          => 4,
  'coding_sequence_variant' => 5,
  'splice_region_variant'   => 5,
  '3_prime_UTR_variant'     => 6,
  '5_prime_UTR_variant'     => 6,
  'synonymous_variant'      => 6,
  'splice_acceptor_variant' => 6,
  'splice_donor_variant'    => 6,
  'stop_retained_variant'   => 7,
  'inframe_variant'         => 7,
  'frameshift_variant'      => 7,
  'missense_variant'        => 8,
  'stop_gained'             => 8,
  'stop_lost'               => 8,
);

# Added this to further narrow down terms to most impact
my %combo = (
  'exon_variant;intron_variant' => 'exon_variant',
  'missense_variant;stop_gained' => 'stop_gained',
  'synonymous_variant;3_prime_UTR_variant' => 'synonymous_variant',
  '5_prime_UTR_variant;synonymous_variant' => 'synonymous_variant',
  'synonymous_variant;5_prime_UTR_variant' => 'synonymous_variant',  
  'stop_lost;missense_variant' => 'stop_lost',
  'missense_variant;stop_lost' => 'stop_lost',
  '5_prime_UTR_variant;3_prime_UTR_variant' => '5_prime_UTR_variant;3_prime_UTR_variant',
  'splice_donor_variant;5_prime_UTR_variant;synonymous_variant' => 'splice_donor_variant',
  'splice_donor_variant;5_prime_UTR_variant' => 'splice_donor_variant',
  'splice_acceptor_variant;synonymous_variant' => 'splice_acceptor_variant',
  'splice_acceptor_variant;3_prime_UTR_variant' => 'splice_acceptor_variant',
  '5_prime_UTR_variant;splice_acceptor_variant' => 'splice_acceptor_variant',
);

=cut

# Need to change rankings to most impact versus location in SO
my %terms = (
  'sequence_variant'        => 1,
  'gene_variant'            => 2,
  'transcript_variant'      => 3,
  'exon_variant'            => 4,
  'intron_variant'          => 4,
  'coding_sequence_variant' => 5,
  'splice_region_variant'   => 5,
  '3_prime_UTR_variant'     => 6,
  '5_prime_UTR_variant'     => 6,
  'synonymous_variant'      => 6,
  'splice_acceptor_variant' => 6,
  'splice_donor_variant'    => 6,
  'stop_retained_variant'   => 7,
  'inframe_variant'         => 7,
  'frameshift_variant'      => 7,
  'missense_variant'        => 8,
  'stop_gained'             => 9,
  'stop_lost'               => 9,
);

=cut

while (<$fh>) {

  chomp $_;
  my ($chr, $start, $end, $ids, $terms, $tool) = split('\t', $_);
  # Need to account for positions where there is no term or 
  # where there is already 1 term for that line
  if (($terms eq '.') || ($terms !~ /;/)) {
    print "$_\n";
    next;
  }
  else {
    my @effects = split(';', $terms);
    my %comparison;
    # Make hash with effects for current line with their values
    foreach (@effects) {
      if (exists $terms{$_}) {
        $comparison{$_} = $terms{$_};
      } 
    }

    # What if a line has 2 or more terms with equal rank and highest?
    # Input: exon_variant;gene_variant;transcript_variant;intron_variant
    # Output: exon_variant
    # Correct output: exon_variant;intron_variant 
    # If 2 terms are the lowest rank and the same, print both terms
    # Process these lines differently than List::UtilsBy max_by method
    my @values = values(%comparison);
    my @sorted_values = sort { $b <=> $a } @values;

    # Compare first 2 elements of array
    # If equal, this means that there are 2 or more terms
    # with the highest value (lowest from all the terms in SO)
    if ($sorted_values[0] == $sorted_values[1]) {
      # Only print terms with highest value
      my @lowest_terms;
      foreach my $key (keys %comparison) {
        if ($comparison{$key} == $sorted_values[0]) {
          push (@lowest_terms, $key); 
        }
      }
      my $trim_terms = join ';', @lowest_terms;
      if (exists $combo{$trim_terms}) {
        $trim_terms = $combo{$trim_terms}; 
        print "$chr\t$start\t$end\t$ids\t$trim_terms\t$tool\n";
      }
    } 
    else {
      # Use max_by to get the 1 term lowest in the ontology
      my $highest = max_by { $comparison{$_} } keys %comparison;
      print "$chr\t$start\t$end\t$ids\t$highest\t$tool\n";
    }
  }

}
close $fh;

__END__
# If I wanted to splice out amino_acid_substitution from @effects
my $count = 0; # Need this before iterating over @effects

if ($_ eq 'amino_acid_substitution') {
  splice @effects, $count, 1;
  $count++;
}

