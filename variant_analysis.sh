#!/bin/sh

# Checking annovar_refGene.txt to see what kind of transcript IDs are in it (NM_, NR_, etc)
awk '$i=substr($i,1,3)' annovar_refGene.txt | sort | uniq -c

# Find all variants with more than 1 alternate allele
grep -v "^#" SeattleSeqAnnotation138.NA12878_Y_removed.vcf.359966521039.txt | awk '{print $5}' | awk '$0 ~ /,/ {print $0}' | less -S
