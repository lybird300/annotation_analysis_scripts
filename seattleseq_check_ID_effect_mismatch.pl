#!/usr/bin/perl
use strict;
use warnings;
use Scalar::MoreUtils qw(empty);

# I want to parse SeattleSeq output and get variants with more than 1
# effect and more than 1 transcript ID and the numbers of effects and
# transcript IDs are not equal.

my $file = shift;
open (FH, $file) or die "Can't open $file:$!\n";

while (my $line = <FH>) {
  chomp $line;
  next if $line =~ '^#';
  my @vcf_cols = split (/\t/, $line);
  my @attributes = split(';', $vcf_cols[7]);
  my $trxn_list;
  my $var_list;
  foreach (@attributes) {
    if ($_ =~ /GM=(.*)/) {
      $trxn_list = $1;
    }
    if ($_ =~ /FG=(.*)/) {
      $var_list = $1;
    }
  } 
  if ((not empty $trxn_list) && (not empty $var_list)) {
    if (($trxn_list !~ /,/) && ($var_list =~ /,/)) {
      my @transcripts = split(',',$trxn_list);
      my @effects = split(',',$var_list);
      if (scalar @effects != scalar @transcripts) {
        print "$vcf_cols[0]".":"."$vcf_cols[1]".":"."$vcf_cols[2]\n";
      }
    }
  }
}
close FH;

