#!/bin/bash

#----- USER SETTINGS -----
R1="$1"
R2="$2"

# Extract base name from R1 (remove .fastq or .fastq.gz)
BASE=$(basename "$R1")
BASE="${BASE%%.fastq*}"      # remove .fastq or .fastq.gz

OUT="${BASE}_bt2.sam"

# Run bowtie2
bowtie2 -x ~/ref_genome/index \
    -1 "$R1" \
    -2 "$R2" \
    -S "$OUT" \
    -p 8 > "${BASE}_dist_bt2.log" 2>&1
