#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use DBD::mysql;

# Filter adjusted_trimmed_variant_tables so I only get variants with the
# same transcript ID annotated by all tools

##########################################################################
# Examples:
# This position has 2 transcripts that are the same for all tools
# Both transcript IDs should be listed
# 1:1254841:1254841	NM_001256460;NM_017871
#
# NM_018406 is in multiple positions but it's ok if it is listed for 
# multiple positions. I want all unique positions but it's ok if the
# same transcript is listed for multiple positions. 
##########################################################################

my $db = 'variant_annotation_analysis';
my $host = 'localhost';
my $user = 'root';
my $password = 'BMI!Utah26';

my $file = "all_tools_transcripts.txt";
open (my $fh, "<", $file) or die "Can't open $file $!\n";

my %transcripts;

while (<$fh>) {
  # Position needs to be the key since there are multiple transcripts for
  # each position and the same transcript for multiple positions.
  chomp $_;
  my ($pos, $id) = split("\t",$_);
  push @{$transcripts{$pos}}, $id;  
}

#connect to MySQL database
my $dbh = DBI->connect("DBI:mysql:database=$db:host=$host", $user, $password) or die "Can't connect to database: $DBI::errstr\n";

#prepare the query
my $sth = $dbh->prepare("select * from adjusted_trimmed_variant_tables where transcript !='.'");
#my $sth = $dbh->prepare("select * from adjusted_trimmed_variant_tables where start = 1254841");
#my $sth = $dbh->prepare("select * from adjusted_trimmed_variant_tables where transcript like '%NM_001256460%' OR transcript like '%NM_017871%'");

#execute the query
$sth->execute( );

while (my @row = $sth->fetchrow_array( )) {
  # Remove ID given by MySQL 
  shift(@row);
  # Some tools have multiple transcript IDs separated by ;
  my @row_transcripts = split(';', $row[3]);
  # Store all transcript IDs that match and print all at end
  my @matches;
  my $row_pos = $row[0].":".$row[1].":".$row[2];
  foreach my $row_trx (@row_transcripts) { 
    # Remove quotes around string in mysql table
    #my $trx= substr $_, 1, -1;
    # Need to remove the decimal and trailing number for comparison
    $row_trx =~ /([A-Z_\d]*)(.\d*)?/;
    #$row_trx = $1;
    # Make sure I'm comparing stripped ID with hash value and
    # add original value to @matches
    foreach my $hash_trx (@{$transcripts{$row_pos}}) {
      if ($1 eq $hash_trx) {
        push (@matches, $row_trx);
      }
    }
  }
  # Execute if some of the transcripts matched to transcripts in hash
  # Do I want to print transcript ID that has decimal and num removed?
  if (@matches) {
    my $transcripts = join(";",@matches);
    splice(@row, 3, 1, $transcripts);
    print join("\t", @row);
    print "\n";
  }
}

warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err( );

exit;

