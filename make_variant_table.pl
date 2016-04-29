#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

=cut

# This works for VAAST, snpEff (GVF), SeattleSeq (GVF)
# TODO: Get this to work later. Also include an option to print 
# tables by chromosome.

my $usage = "

Synopsis:

perl make_variant_table.pl --file file.gvf --tool VAAST

Description:

This script takes a file with variant annotation data in GVF, 
pulls out variant effect info for each position and outputs 
this in a table format.

Options:

  --file
    Annotated GVF file

  --tool
    Name of annotation tool that created the file

";

my ($help, $file, $tool);

my $opt_success = GetOptions("help|h" => \$help,
	   "file|f=s" => \$file,
           "tool|t=s" => \$tool);
die $usage unless $opt_success;
if ($help) {
  print $usage;
  exit(0);
}

=cut

my ($file, $tool);
GetOptions('file=s' => \$file, 
	   'tool=s' => \$tool)
or die("Error in command line arguments\n");

open (my $fh, '<', $file) or die "ERROR: A file is required: $!";

print "Position\tTranscript_ID\t$tool\n";

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
