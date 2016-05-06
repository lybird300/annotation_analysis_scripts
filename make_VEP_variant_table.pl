#!/usr/bin/perl
use strict;
use warnings;
use Scalar::MoreUtils qw(empty);

# This script takes a VEP file with variant annotation data in GVF,
# pulls out variant effect info for each position and outputs
# this in a table format. 
# TODO: Integrate this with make_variant_table.pl
# They are separate because VEP GVF is slightly different than 
# what the specs specify. VEP has Variant_effect= for each effect
# when it should only have that one time and then each effect
# separated by a comma.
 
my $vep_file = shift;
open (FH, '<', $vep_file) or die "Can't open $vep_file:$!\n";

print "Position\tTranscript_ID\tVEP\n";

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
  
  if ($attributes !~ /Variant_effect=/) {
    print "$pos\t.\t.\n";
  }
  else{
  foreach my $a (@attributes) {
    if ($a =~ /Variant_effect=/) {
      my ($effect, $index, $feature, $id) = split(/\s/, $a);
      $effect =~ /Variant_effect=(.*)/;
      push(@effects, $1);

      # For now, I'm limiting transcripts to refseq only 
      # TODO: Make a command line option that would specify
      # if you want all transcript IDs or not.
      if ($id =~ /^[NMRXP]{2}_/) {
        $transcripts{$id}++;
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
