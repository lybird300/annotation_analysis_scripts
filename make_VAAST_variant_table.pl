#!/usr/bin/perl
use strict;
use warnings;

my $file = shift;
open (FH, '<', $file) or die "Can't open $file:$!\n";

print "Position\tTranscript_ID\tVAAST\n";

while (my $line = <FH>) {
  chomp $line;
  if ($line =~ '^#') {
    next;
  }
  my ($chr, $source, $type, $start, $end, $score, $strand, 
      $phase, $attributes) = split(/\t/, $line);
  my @attributes = split(';', $attributes);
  my $pos = $chr.':'.$start.':'.$end;
  my @effects;
  my %transcripts;
  my $all_effects;
  my $all_trxns;
 
  # Need to print out position even if there is no effect 
  if ($attributes !~ /Variant_effect=/) {
    print "$pos\n";
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
        shift @ann for 1..3;
        foreach (@ann) {
          if ($_ =~ /[NMRXP]{2}_/) {
          # Need to account for multiple transcripts IDs
          # I also don't want to print out duplicate IDs
            $transcripts{$_}++;
          }
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
  print "$pos\t$all_trxns\t$all_effects\n";
  }
}
close FH;

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
