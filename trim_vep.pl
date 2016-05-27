#!/usr/bin/perl
use strict;
use warnings;
use Scalar::MoreUtils qw(empty);

# Create file with 1 VEP effect per line
my $gvf = shift;
my $table = shift;
open (my $fh1, '<', $gvf) or die "Can't open $gvf. $!";
open (my $fh2, '<', $table) or die "Can't open $table. $!";

my %gvf_terms;

while (<$fh1>) {
  chomp $_;
  my @gvf = split '\t', $_;
  my $key = $gvf[0].':'.$gvf[3].':'.$gvf[4];
  my @attributes = split ';', $gvf[8];
  foreach (@attributes) {
    if ($_ =~ /Variant_effect=(.*)\s\d/) {
      $gvf_terms{$key} = $1;
    }
  }
}

while (<$fh2>) {
  chomp $_;
  my ($chr, $start, $end, $ids, $terms, $tool) = split('\t', $_);
  if (($terms eq '.') || ($terms !~ /;/)) {
    print "$_\n";
    next;
  }
  else {
    my $key = $chr.':'.$start.':'.$end;
    if (exists $gvf_terms{$key}) { 
      my @effects = split(';', $terms);
      my $most_severe; 
      foreach (@effects) {
        if ($gvf_terms{$key} eq $_) {
          $most_severe = $_;
          print "$chr\t$start\t$end\t$ids\t$most_severe\t$tool\n";
          last;
        }
      }
      if (empty $most_severe) {
        print "VCF_GVF_term_mismatch\n";
      }
    }
    else {
      print "Converted_GVF_VEP_GVF_mismatch\n";
    }
  }
}
close $fh1;
close $fh2;
