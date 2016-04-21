#!/bin/sh

# Checking annovar_refGene.txt to see what kind of transcript IDs are in it (NM_, NR_, etc)
awk '$i=substr($i,1,3)' annovar_refGene.txt | sort | uniq -c
