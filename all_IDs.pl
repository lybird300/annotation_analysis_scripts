#!/usr/bin/perl
use strict;
use warnings;

# I want to see the different types of transcript IDs
# that are in the variant table file.

my $file = shift;
open(my $fh, '<', $file) or die "Can't open $file:$!\n";

while (my $line = <$fh>) {
  chomp $line;
  if ($line =~ "^Position") {
    next;
  }
  my @cols = split('\t', $line);
  my @transcripts = split(';', $cols[1]);
  foreach (@transcripts) {
    if ($_ =~ /(^[NMRXP]{2}_)/) {
      print "$1\n";
      next;
    }
    # match will have either 4 or 7 characters
    if ($_ =~ /(^[ENSTG]{4,7})/) {
      print "$1\n";
    }

=cut
   
   # This is to check for other non-transcript ID strings 
   # like gene symbols
   my $sub = substr $_, 0, 3; 
   print "$sub\n";

=cut

  }
}
close $fh;
