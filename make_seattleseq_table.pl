#!/usr/bin/perl
use strict;
use warnings;

my $file = shift;
open (FH, '<', $file) or die "Can't open $file:$!\n";

print "Position\tTranscript_ID\tSeattleseq\n";

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
  my @transcripts;
  my $all_effects;
  my $all_trxns;
  
  # Print variant position if there is no effect
  # Need to know if there are variants that don't have annotation
  if ($attributes !~ /Variant_effect=/) {
    print "$pos\n";
  }
  else {
    foreach my $a (@attributes) {
      if ($a =~ /Variant_effect=/) {
        my @annos = split(',', $a);
        foreach my $ann (@annos) {
          my @ann = split(/\s/, $ann);
          my $effect = $ann[0];
          if ($effect =~ /Variant_effect=(.*)/) {
            push(@effects, $1);
          }
          else {
            push(@effects, $effect);
          }
          shift @ann for 1..3;
          push(@transcripts, @ann);
        }
      }
    }

  if (scalar @effects > 1) {
    $all_effects = join(';', @effects);
  }
  else {
    $all_effects = "@effects";
  }
  if (scalar @transcripts > 1) {
    $all_trxns = join(';', @transcripts);
  }
  else {
    $all_trxns = "@transcripts";
  }
  print "$pos\t$all_trxns\t$all_effects\n";
  }
}
close FH;

=cut

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

=cut

