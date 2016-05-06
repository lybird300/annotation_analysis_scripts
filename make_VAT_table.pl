#!/usr/bin/perl
use strict;
use warnings;
use Scalar::MoreUtils qw(empty);

# This works for VAT only because there are Ensembl IDs
# TODO: Get make_variant_table.pl to process this type of output. 

my $file = shift;
open (my $fh, '<', $file) or die "ERROR: A file is required: $!";

print "Position\tTranscript_ID\tVAT\n";

while (<$fh>) {
  chomp $_;
  if ($_ =~ '^#') {
    next;
  }
  my ($chr, $source, $type, $start, $end, $score, $strand, 
      $phase, $attributes) = split(/\t/, $_);
  my @attributes = split(';', $attributes);
  my $pos = $chr.':'.$start.':'.$end;
  my @effects;
  my %transcripts;
  my $all_effects;
  my $all_trxns;
 
  # Need to print out position even if there is no effect 
  # Some variants don't have transcript IDs
  # Some variants don't have effects
  # Need to print . in columns that are blank
  if ($attributes !~ /Variant_effect=/) {
    print "$pos\t.\t.\n";
  }
  else { 
  foreach my $a (@attributes) {
    if ($a =~ /Variant_effect=/) {
      my @annos = split(',', $a);
      foreach (@annos) {
        my @ann = split(/\s/, $_);
        my $effect = $ann[0];
        if ($effect =~ /Variant_effect=(.*)/) {
          push(@effects, $1);
        }
        else {
          push(@effects, $effect);
        }
        # I don't want to include gene names
        # in transcript ID list.
        # Ex: gene_variant 0 gene WASH7P
        #shift @ann for 1..3;
        shift @ann for 0..2;
        foreach (@ann) {
          #if ($_ =~ /[NMRXP]{2}_/) {
          # Need to account for multiple transcripts IDs
          # I also don't want to print out duplicate IDs
            $transcripts{$_}++;
          #}
        }
      }
    }
  }
  if (scalar @effects > 1) {
    $all_effects = join(';', @effects);
  }
  else {
    $all_effects = "@effects";
  }

  my @transcripts = keys %transcripts;
  $all_trxns = join(';', @transcripts);
  if (empty $all_trxns) {
    print "$pos\t.\t$all_effects\n";
  }
  else {
    print "$pos\t$all_trxns\t$all_effects\n";
  }
 }
}
close $fh;

__END__
# Separate each effect and/or transcript ID into its own line
# Only print out NM accession numbers
  foreach my $a (@attributes) {
      if ($a =~ /Variant_effect=/) {
        my ($effect, $index, $feature, $id) = split(/\s/, $a);
        $effect =~ /Variant_effect=(.*)/;
        my $new_effect = $1; 
        #if ($id =~ /NM_/) {
          print "$pos\t$id\t$new_effect\n";
        #}
      }
  }
}

close FH;
