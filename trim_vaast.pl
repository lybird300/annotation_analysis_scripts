#!/usr/bin/perl
use strict;
use warnings;
use List::UtilsBy qw(max_by);

# 1. I want to remove amino_acid_substitution from VAAST column
#    amino_acid_substitution has other terms around it for all cases
#    when it appears in the file.
# 2. I want to reduce the number of effects listed only to the most
#    specific in the VAAST column.

#my $file = '../table_files/vaast.txt';
my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file. $!";

my %terms = (
  'sequence_variant' => 1,
  'gene_variant' => 2,
  'transcript_variant' => 3,
  'exon_variant' => 4,
  'intron_variant' => 4,
  'coding_sequence_variant' => 5,
  'splice_region_variant' => 5,
  '3_prime_UTR_variant' => 6,
  '5_prime_UTR_variant' => 6,
  'synonymous_variant' => 6,
  'splice_acceptor_variant' => 6,
  'splice_donor_variant' => 6,
  'stop_retained_variant' => 7,
  'inframe_variant' => 7,
  'frameshift_variant' => 7,
  'missense_variant' => 8,
  'stop_gained' => 8,
  'stop_lost' => 8,
);

while (<$fh>) {

  chomp $_;
  my ($chr, $start, $end, $ids, $terms, $tool) = split('\t', $_);
  # Need to account for positions where there is no term
  if ($terms eq '.') {
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
    # Get the term lowest in the ontology 
    my $highest = max_by { $comparison{$_} } keys %comparison;
    print "$chr\t$start\t$end\t$ids\t$highest\t$tool\n";
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

