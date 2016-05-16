#!/usr/bin/perl
use strict;
use warnings;

my $file = shift;
open(my $fh, '<', $file) or die "Can't open $file $!\n";

#print "Chr\tStart\tEnd\tTranscript_ID\tEffect\tTool\n";

while (<$fh>) {
  chomp $_;
  next if $_ =~ "^Position";
  my @cols = split('\t', $_);
  my ($chr, $start, $end) = split(':', $cols[0]);
  print "$chr\t$start\t$end\t$cols[1]\t$cols[2]\t$cols[3]\n";
}
