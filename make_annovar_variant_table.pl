#!/usr/bin/perl
use strict;
use warnings;

# This script takes the ANNOVAR .annovar_multianno.txt output 
# from table_annovar.pl and pulls out chr, start, end, transcript ID 
# and variant effects for each line
my $file = shift;
open (FH, '<', $file) or die "Can't open $file:$!\n";

print "Position\tTranscript_ID\tANNOVAR\n";

while (my $line = <FH>) {
  chomp $line;
  if ($line =~ '^Chr') {
    next;
  }
  my ($chr, $start, $end, $ref, $alt, $ann, $gene, $gene_detail, 
      $exonic_ann, $aa, $vcf_file_cols) = split(/\t/, $line);
  my $pos = $chr.':'.$start.':'.$end;

=cut

These are column 9 and 10 with the transcript ID on column 11:

synonymous SNV
nonsynonymous SNV
frameshift deletion
nonframeshift deletion
nonframeshift insertion
frameshift insertion
frameshift substitution
nonframeshift substitution

unknown UNKNOWN
col 9: $exonic_ann = unknown
col 10: $aa = UNKNOWN

The rest of the annotations are on column 9 with the transcript ID on 
column 10

=cut

  if (($ann eq "exonic") & ($exonic_ann ne "unknown")) {
    $ann = "exon_variant";
    if ($aa !~ ':') {
      $exonic_ann = $exonic_ann." ".$aa;
      $aa = $vcf_file_cols;
    }
    my $complete_ann = $ann.';'.$exonic_ann;
    my @all_aa = split(',',$aa);
    my $trxs;
    my @trxs;
    foreach (@all_aa) {
      my ($gene, $transcript, $exon, $hgvs_c, $hgvs_p) = split(':', $_);
      push(@trxs, $transcript);
    }
    if (scalar @trxs > 1) {
      $trxs = join(';', @trxs);
    }
    else {
      $trxs = "@trxs";
    }
    print "$pos\t$trxs\t$complete_ann\n";  
  }
  else {
    # Handle non-exonic and unknown annotations
    if (($exonic_ann eq "unknown") & ($ann eq "exonic")) {
      $ann = "exon_variant";
    }
    print "$pos\t$exonic_ann\t$ann\n";
  }
}

close FH;
