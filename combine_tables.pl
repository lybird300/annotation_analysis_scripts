#!/usr/bin/perl
use strict;
use warnings;

# This script combines all of the variant tables into 1 file with 
# all variants that are annotated by all tools

print "Position\tAnnovar_Transcript_ID\tAnnovar\tSeattleseq_Transcript_ID\tSeattleseq\tsnpEff_Transcript_ID\tsnpEff\tVAAST_Transcript_ID\tVAAST\n";

# -t '\t' only needs the $ in front of it when entering this directly on the command line
# tab-delimited output could also be specified as '-t	' with a literal tab
# Don't forget to add the other columns in the join output as you continue joining files!
my $cmd = "join -t '\t' -o 1.1,1.2,1.3,2.2,2.3 annovar_chr19.txt seattleseq_chr19.txt | join -t '\t' -o 1.1,1.2,1.3,1.4,1.5,2.2,2.3 - snpeff_chr19.txt | join -t '\t' -o 1.1,1.2,1.3,1.4,1.5,1.6,1.7,2.2,2.3 - vaast_chr19.txt";
system("$cmd") == 0 or die "Error running $cmd\n";
