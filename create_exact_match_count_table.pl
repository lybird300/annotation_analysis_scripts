#!/usr/bin/perl
use strict;
use warnings;

# Creates file for effect_match_count table in mysql
# Each position is listed with each tool and a count of what
# each tool annotated the position as.
# 1 = tool annotates position with that term
# 0 = tool does not use that term

my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file $!\n";

my %terms_per_pos;

while(<$fh>) {

  chomp $_;
  next if $_ =~ "^id";
  my ($id, $chr, $start, $end, $trxn, $effect, $tool) = split '\t', $_;
  my $pos = $chr.':'.$start.':'.$end;
  my @effects = split ';', $effect;

  foreach (@effects) {
    push @{$terms_per_pos{$pos}{$_}}, uc $tool; 
  } 

}

print "Chr\tStart\tEnd\tEffect\tANNOVAR\tSEATTLESEQ\tSNPEFF\t".
      "VAAST\tVAT\tVEP\n";

# 10 would be ahead of 1 when keys are sorted this way
my @positions = sort keys %terms_per_pos;

foreach my $pos (@positions) {
 
  my ($chr, $start, $end) = split ':', $pos;
  foreach my $term (sort keys % { $terms_per_pos{$pos} } ) {
    my $annovar = 0;
    my $seattleseq = 0;
    my $snpeff = 0;
    my $vaast = 0;
    my $vat = 0;
    my $vep = 0; 

    foreach (@{$terms_per_pos{$pos}{$term}}) {
      if ($_ eq 'ANNOVAR') {
        $annovar = 1;
      }
      elsif ($_ eq 'SEATTLESEQ') {
        $seattleseq = 1;
      }
      elsif ($_ eq 'SNPEFF') {
        $snpeff = 1;
      }
      elsif ($_ eq 'VAAST') {
        $vaast = 1;
      }
      elsif ($_ eq 'VAT') {
        $vat = 1;
      }
      else {
        $vep = 1;
      }
    }
    print "$chr\t$start\t$end\t$term\t$annovar\t$seattleseq\t$snpeff\t".
          "$vaast\t$vat\t$vep\n";
  }

}

close $fh;
