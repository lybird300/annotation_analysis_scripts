#!/usr/bin/perl
use strict;
use warnings;
use Scalar::MoreUtils qw(empty);

# Convert ensembl transcript IDs in VAT output to RefSeq IDs
my $map_file = $ARGV[0];
my $vat_file = $ARGV[1];
open (my $fh1, '<', $map_file) or die "Can't open $map_file $!\n";
open (my $fh2, '<', $vat_file) or die "Can't open $vat_file $!\n";

my %ensembl_ids;
while (<$fh1>) {
  chomp $_;
  next if $_ =~ '^Ensembl';
  my ($enst, $nm, $xm) = split('\t', $_);
  if ((empty $nm) && (empty $xm)) {
    next; 
  }
  if (empty $xm) {
    push (@{$ensembl_ids{$enst}{'refseq'}}, $nm);
  }
  elsif (empty $nm) {
    push (@{$ensembl_ids{$enst}{'refseq'}}, $xm);
  }
  else {
    push (@{$ensembl_ids{$enst}{'refseq'}}, $nm, $xm);
  }
}

while(<$fh2>) {
  chomp $_;
  if ($_ =~ "^Position") {
    print "$_\n";
    next;
  }
  my ($pos, $id, $ann) = split('\t', $_);
  my @mapped_ids;
  # If you remove the decimal and trailing number before running this
  # it won't work the right way.
  $id =~ /(ENST[\d]*)./; 
  if (exists $ensembl_ids{$1}) {
    if (@{$ensembl_ids{$1}{'refseq'}} > 1) {
      push (@mapped_ids, @{$ensembl_ids{$1}{'refseq'}});
    }
    else {
      $id = "@{$ensembl_ids{$1}{'refseq'}}";
    } 
  }
  else {
    $id = ".";
  }

  if (@mapped_ids) {
    my $new_ids = join(';', @mapped_ids);
    print "$pos\t$new_ids\t$ann\n";
  } 
  else {
    print "$pos\t$id\t$ann\n";
  }

}

close $fh1;
close $fh2;
