# General pipeline for analyzing open chromatin datasets

Prior to this: generate QC'd and trimmed fastq files
1. Map your reads to the reference genome
2. Process mapped reads
   - sort, remove duplicates, remove plasmid alignments
   - convert to binary
3. Call accessible chromatin regions (ACRs)
4. Create your signal track

## 1. Map your reads to the reference genome
If working with single-end (SE), use 'map.sh'. If paired-end (PE), use map_PE.sh.
```
### This script looks for all files ending with '*_trimmed.fastq.gz' in path '/home/trimmed_dir/'. It also relies on your bowtie2 index being in path '~/ref_genome/index'
### Output: sam file
sh map.sh

### This script relies on your bowtie2 index being in path '~/ref_genome/index'.
### Output: sam file  +  mapping log '*_dist_bt2.log'
sh map_PE.sh $R1 $R2
```
## 2. Process mapped reads

Use 'samtools_sort.sh' to sort reads, remove duplicates, and remove plasmid alignments. This script specifically removes plasmid alignments located on regions 'NC_037304.1' and 'NC_000932.1' (NCBI IDs for chloroplast and mitochondria in _Arabidopsis thaliana_)

```
### indicate whether SE or PE
### Output: sam file with suffix '_sorted_rmdup.sam'
sh samtools_sort.sh $IN.sam $single|paired
samtools view -bS $IN_sorted_rmdup.sam > $IN_sorted_rmdup.bam
```

## 3. Call accessible chromatin regions (ACRs)

```
## adjust chromosome size file path
fseq2 callpeak $IN_sorted_rmdup.bam -chrom_size_file ~/ref_genome/chrom_size.tab -name $IN_fseq2 -f 0 -l 300 -cpus 20 -fc 20 -q_thr 0.01 &
```

## 4. Create your signal track

```
### generate bam index file
samtools index $IN_sorted_rmdup.bam
### create your track
bamCoverage -b $IN_sorted_rmdup.bam -o $IN_sorted_rmdup.bw -p 25 --binSize 1 --normalizeUsing CPM &
```
