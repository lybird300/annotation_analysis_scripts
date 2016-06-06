#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use DBD::mysql;

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

my %variants;
while ( my @row = $sth->fetchrow_array( ) )  {
	my $key = $row[0] . ":" . $row[1] . ":" . $row[2];
	push (@{$variants{$key}{$row[3]}}, $row[4]);
}

my %combinations;
foreach my $pos (keys %variants) {
  foreach my $effect (keys %{$variants{$pos}}) {
    my @effects = sort @{$variants{$pos}{$effect}};
    my $key = join "/", @effects;
    $combinations{$key}++;
  }
}

foreach my $group (keys %combinations) {
  print "$group\t$combinations{$group}\n";
}

warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err( );

exit;

