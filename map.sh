#!/bin/bash 

 # Loop through all files ending with *_trimmed.fastq.gz

for file in /home/trimmed_dir/*_trimmed.fastq.gz; do
    if [[ -f "$file" ]]; then  # Ensure it's a file
        # Extract the base name (without extension)
        BASE=$(basename "$file" .fastq)
        OUT="${BASE}_bt2.sam"
# Change this to whatever directory you have your bowtie2 index
        bowtie2 -x ~/ref_genome/index -q "$file" -S "$OUT" -p 12 > "${BASE}_dist_bt2.log" 2>&1
    else
        echo "no *_trimmed.fastq files found"
    fi
done
