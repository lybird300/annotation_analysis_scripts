#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use DBD::mysql;
use List::Compare;
use Data::Dumper;

my $db = 'variant_annotation_analysis';
my $host = 'localhost';
my $user = 'root';
my $password = '';

#connect to MySQL database
my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
                          $user,
                          $password) 
                          or die "Can't connect to database: $DBI::errstr\n";

#prepare the query
my $sth = $dbh->prepare("select chr, start, end, effect, tool from adjusted_trimmed_variant_tables order by start, end, effect");

#execute the query
$sth->execute( );
## Retrieve the results of a row of data and print
print "\tQuery results:\n================================================\n";

my %variants;
while ( my @row = $sth->fetchrow_array( ) )  {
        ################################# DO WORK HERE ############################ 
	my $key = $row[0] . ":" . $row[1] . ":" . $row[2] . ":" . $row[3];
	push (@{$variants{$key}}, $row[4]);
}

# can't use arrays as keys of hash
my %combo_2 = (
  "ANNOVAR/Seattleseq" => 0,
  "ANNOVAR/snpEff" => 0,
  "ANNOVAR/VAAST" => 0,
  "ANNOVAR/VAT" => 0,
  "ANNOVAR/VEP" => 0,
  "Seattleseq/snpEff" => 0,
  "Seattleseq/VAAST" => 0,
  "Seattleseq/VAT" => 0,
  "Seattleseq/VEP" => 0,
  "snpEff/VAAST" => 0,
  "snpEff/VAT" => 0,
  "snpEff/VEP" => 0,
  "VAAST/VAT" => 0,
  "VAAST/VEP" => 0,
  "VAT/VEP" => 0,
);

foreach my $key (keys %variants) {
  foreach my $combo (keys %combo_2) {
    my @combo = split "/", $combo;
    my $compare = List::Compare->new(\@{$variants{$key}}, \@combo);
    my @diff = $compare->get_symmetric_difference;
    if (! @diff) {
      $combo_2{$combo}++;
    }
  }
}

my %combo_3 = (
  "ANNOVAR/Seattleseq/snpEff" => 0,
  "ANNOVAR/Seattleseq/VAAST" => 0,
  "ANNOVAR/Seattleseq/VAT" => 0,
  "ANNOVAR/Seattleseq/VEP" => 0,
  "ANNOVAR/snpEff/VAAST" => 0,
  "ANNOVAR/snpEff/VAT" => 0,
  "ANNOVAR/snpEff/VEP" => 0,
  "ANNOVAR/VAAST/VAT" => 0,
  "ANNOVAR/VAAST/VEP" => 0,
  "ANNOVAR/VAT/VEP" => 0,
  "Seattleseq/snpEff/VAAST" => 0,
  "Seattleseq/snpEff/VAT" => 0,
  "Seattleseq/snpEff/VEP" => 0,
  "Seattleseq/VAAST/VAT" => 0,
  "Seattleseq/VAAST/VEP" => 0,
  "Seattleseq/VAT/VEP" => 0,
  "snpEff/VAAST/VAT" => 0,
  "snpEff/VAAST/VEP" => 0,
  "snpEff/VAT/VEP" => 0,
  "VAAST/VAT/VEP" => 0,
);

foreach my $key (keys %variants) {
  foreach my $combo (keys %combo_3) {
    my @combo = split "/", $combo;
    my $compare = List::Compare->new(\@{$variants{$key}}, \@combo);
    my @diff = $compare->get_symmetric_difference;
    if (! @diff) {
      $combo_3{$combo}++;
    }
  }
}

my %combo_4 = (
  "ANNOVAR/Seattleseq/snpEff/VAAST" => 0,
  "ANNOVAR/Seattleseq/snpEff/VAT" => 0,
  "ANNOVAR/Seattleseq/snpEff/VEP" => 0,
  "ANNOVAR/Seattleseq/VAAST/VAT" => 0,
  "ANNOVAR/Seattleseq/VAAST/VEP" => 0,
  "ANNOVAR/Seattleseq/VAT/VEP" => 0,
  "ANNOVAR/snpEff/VAAST/VAT" => 0,
  "ANNOVAR/snpEff/VAAST/VEP" => 0,
  "ANNOVAR/snpEff/VAT/VEP" => 0,
  "ANNOVAR/VAAST/VAT/VEP" => 0,
  "Seattleseq/snpEff/VAAST/VAT" => 0,
  "Seattleseq/snpEff/VAAST/VEP" => 0,
  "Seattleseq/snpEff/VAT/VEP" => 0,
  "Seattleseq/VAAST/VAT/VEP" => 0,
  "snpEff/VAAST/VAT/VEP" => 0,
);

foreach my $key (keys %variants) {
  foreach my $combo (keys %combo_4) {
    my @combo = split "/", $combo;
    my $compare = List::Compare->new(\@{$variants{$key}}, \@combo);
    my @diff = $compare->get_symmetric_difference;
    if (! @diff) {
      $combo_4{$combo}++;
    }
  }
}

my %combo_5 = (
  "ANNOVAR/Seattleseq/snpEff/VAAST/VAT" => 0,
  "ANNOVAR/Seattleseq/snpEff/VAAST/VEP" => 0,
  "ANNOVAR/Seattleseq/snpEff/VAT/VEP" => 0,
  "ANNOVAR/Seattleseq/VAAST/VAT/VEP" => 0,
  "ANNOVAR/snpEff/VAAST/VAT/VEP" => 0,
  "Seattleseq/snpEff/VAAST/VAT/VEP" => 0,
);

foreach my $key (keys %variants) {
  foreach my $combo (keys %combo_5) {
    my @combo = split "/", $combo;
    my $compare = List::Compare->new(\@{$variants{$key}}, \@combo);
    my @diff = $compare->get_symmetric_difference;
    if (! @diff) {
      $combo_5{$combo}++;
    }
  }
}

my %combo_6 = (
  "ANNOVAR/Seattleseq/snpEff/VAAST/VAT/VEP" => 0,
);

foreach my $key (keys %variants) {
  foreach my $combo (keys %combo_6) {
    my @combo = split "/", $combo;
    my $compare = List::Compare->new(\@{$variants{$key}}, \@combo);
    my @diff = $compare->get_symmetric_difference;
    if (! @diff) {
      $combo_6{$combo}++;
    }
  }
}

print "================================================\n";
print "\tCombinations of 2 tools:\n================================================\n";
foreach my $combo (keys %combo_2) {
  print "$combo\t$combo_2{$combo}\n";
} 
print "================================================\n";
print "\tCombinations of 3 tools:\n================================================\n";
foreach my $combo (keys %combo_3) {
  print "$combo\t$combo_3{$combo}\n";
} 
print "================================================\n";
print "\tCombinations of 4 tools:\n================================================\n";
foreach my $combo (keys %combo_4) {
  print "$combo\t$combo_4{$combo}\n";
} 
print "================================================\n";
print "\tCombinations of 5 tools:\n================================================\n";
foreach my $combo (keys %combo_5) {
  print "$combo\t$combo_5{$combo}\n";
} 
print "================================================\n";
print "\tCombinations of 6 tools:\n================================================\n";
foreach my $combo (keys %combo_6) {
  print "$combo\t$combo_6{$combo}\n";
} 

warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err( );

exit;
