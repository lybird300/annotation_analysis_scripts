#!/bin/sh

# Checking annovar_refGene.txt to see what kind of transcript IDs are in it (NM_, NR_, etc)
awk '$i=substr($i,1,3)' annovar_refGene.txt | sort | uniq -c

# Find all variants with more than 1 alternate allele
grep -v "^#" SeattleSeqAnnotation138.NA12878_Y_removed.vcf.359966521039.txt | awk '{print $5}' | awk '$0 ~ /,/ {print $0}' | less -S

# Look at Transcript ID column (2nd column) of variant table to make sure there are only transcript IDs in this column
grep -v "^Position" ../SeattleSeq/seattleseq_variants.txt | awk '{print substr($2,0,4)}' | sort | uniq -c | less -S

# Get all lines from variant table that have messed up transcript ID columns
grep -v "^Position" vat_indel_variants.txt | awk '$2 !~ /^E/ {print $0}' | less -S

# Check column 1 of VCF (chr) and see which chromosomes are in file and how many lines there are for each chr
grep -v "^#" NA12878_indelmapper.annotated.vcf | awk '{print $1}' | sort | uniq -c | less -S

# Remove all lines that are on chr Y (This does not remove header lines from new file)
awk -F"\t" '!($1=="chrY")' NA12878_indelmapper.annotated.vcf > new_indelmapper.vcf

# Create BED files of GVF files
awk -v OFS='\t' '{print $1,$4,$5}' NA12878_indelmapper.annotated.gvf > indels.bed

# Prints out all 3 columns from annovar file and last column of seattleseq file
# Line is printed only if first column (Position) is in both files
# This assumes files are sorted. If not, then run
# join -o 1.1,1.2,1.3,2.3 <(sort -k2 file1) <(sort -k2 file2)
join -o 1.1,1.2,1.3,2.3 annovar_test.txt seattleseq_test.txt

# Comparing more than 2 files ONLY by position
join -t $'\t' -o 1.1,1.2,1.3,2.2,2.3 annovar_test.txt seattleseq_test.txt | join -t $'\t' -o 1.1,1.2,1.3,1.4,1.5,2.2,2.3 - snpeff_test.txt
