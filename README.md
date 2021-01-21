
#	Read Simulator


Create reads from a reference with added noise to test alignment strategies.


Tried [SiLiCO](https://github.com/ethanagbaker/SiLiCO) and [NanoSim](https://github.com/bcgsc/NanoSim). Looked into [Deep Simulator](https://github.com/liyu95/DeepSimulator) and [SimuSCoP](https://github.com/qasimyu/simuscop).

Need something much simpler.


Then try assembling with [Canu](https://canu.readthedocs.io/en/latest/index.html) or even [Masurca](http://masurca.blogspot.com/)


For example, I'd like to test assembling the HLA/MHC region.
This won't be perfect. I know that.


```BASH
samtools faidx hg38.fa chr6:28,510,120-33,480,577 | sed '1s/^.*$/>mhc/' > hg38-mhc.fa
samtools faidx hg38-mhc.fa 
cat hg38-mhc.fa.fai 
mhc	4970458	5	60	61
```




Something like ...


```BASH
create_fragment_bed.bash --reference hg38-mhc.fa --min_length 1000 --max_length 15000 --count 10000 --output nanopore.bed.gz

bedtools getfasta -name -fi hg38-mhc.fa -bed nanopore.bed.gz -fo nanopore.exact.fasta

add_error_to_fragments.bash --percent 10 nanopore.exact.fasta
```


##	Test with Canu

Generate a variety of test data sets for comparison

```BASH
create_test_data.bash

assemble_test_data.bash
```

canu on the "10x5-50" is perfect. 1 contig 4970458 bp. Perfect!



##	Add error and test shorter segments for consensus


https://www.onelambda.com/en/product/alltype-ngs-reagents.html

Its the alltype 11 kit


11 complete HLA sites? Where? How long? How to consensus each site for each subject? Does canu or the other assemblers provide a consensus?
A (Full gene)
B (Full gene)
C (Full gene)	
DRB1 (Exon 2 - 3' UTR)
DRB345 (Exon 2 - 3' UTR) - not in chr6 hg38.ncbiRefSeq.gtf (in alternates) ( not sure why group names. This is DRB3, DRB4 and DRB5. )
DQB1 (Exon 2 - 3' UTR)
DQA1 (Full gene)
DPB1 (Exon 2 - 3’UTR)
DPA1 (Full gene)




hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf

awk -F"\t" '( ( $1 == "chr6" ) && ( $3 == "transcript" ) )' ./sources/hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf | grep "HLA-" > ./sources/hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.chr6.transcript.HLA.gtf

Manually select longest transcript versions of A, B, C, DRB1, DRB5, DQA1, DQB1, DPA1, DPB1

DRB3 and DRB4 are only in alternate sequences.

bedtools getfasta -fi /francislab/data1/refs/fasta/hg38.fa -bed /francislab/data1/refs/sources/hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.chr6.transcript.selectHLA.gtf -fo /francislab/data1/refs/sources/hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.chr6.transcript.selectHLA.fa -name+










##	Masurca

If matched with Illumina short read data could use Masurca.

Create a config.txt file

```BASH
masurca_install_path/bin/masurca config.txt
assemble.sh
```

