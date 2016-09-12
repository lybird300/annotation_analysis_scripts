#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use DBD::mysql;

# This will get all the transcripts that are annotated by all tools.
# Transcripts annotated by at least 1 tool. This isn't transcripts
# annotated by all tools. filter_table_for_transcripts_all_tools.pl does 
# that.

my $db = 'variant_annotation_analysis';
my $host = 'localhost';
my $user = 'root';
my $password = '';

#connect to MySQL database
my $dbh = DBI->connect("DBI:mysql:database=$db:host=$host", $user, $password) or die "Can't connect to database: $DBI::errstr\n";

#prepare the query
my $sth = $dbh->prepare("select * from adjusted_trimmed_variant_tables where transcript !='.'");
#my $sth = $dbh->prepare("select * from adjusted_trimmed_variant_tables where transcript like '%NM_001256462%'");

#execute the query
$sth->execute( );

my %variants;
while (my @row = $sth->fetchrow_array( )) {
  my $key = $row[1] . ":" . $row[2] . ":" . $row[3];
  # Some tools have multiple transcript IDs separated by ;
  my @transcripts = split(';', $row[4]);
  foreach (@transcripts) { 
    # Need to remove the decimal and trailing number for comparison
    $_ =~ /([A-Z_\d]*)(.\d*)?/;
    push (@{$variants{$key}{$1}}, $row[6]);
  }
}

# Only print IDs annotated by all 6 tools
# array will have 6 values or 0-5 elements
foreach my $pos (keys %variants) {
  foreach my $id (keys %{$variants{$pos}}) {
    my @tools = sort @{$variants{$pos}{$id}};
    if (scalar @tools == 6) {
      print "$pos\t$id\n";
    }
  }
}

warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err( );

exit;

