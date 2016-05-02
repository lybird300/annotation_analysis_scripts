#!/usr/bin/perl
use strict;
use warnings;

# I want to see what the variant with more than 1 alternate variant look like

my $file = shift;
open (my $fh, '<', $file) or die "Can't open $file $!";

while (my $line = <$fh>) {

# If I wanted to take input directly from commandline
## Delete first 2 lines and final line
## Replace $line with $_
## while (<STDIN>) {

  chomp $line;
  next if $line =~ '^#';
  my @cols = split(/\t/, $line);
  if ($cols[8] =~ /Variant_seq=(.*?);/) {
    my $var = $1;
    if ($var =~ /,/) { 
      print "$var\n";
    }
  }      
}
close $fh;
