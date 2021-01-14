
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

	-name		Use the name field and coordinates for the FASTA header
	-name+		(deprecated) Use the name field and coordinates for the FASTA header
	-nameOnly	Use the name field for the FASTA header
	-split		Given BED12 fmt., extract and concatenate the sequences
			from the BED "blocks" (e.g., exons)
	-tab		Write output in TAB delimited format.
			- Default is FASTA format.
	-s		Force strandedness. If the feature occupies the antisense,
			strand, the sequence will be reverse complemented.
			- By default, strand information is ignored.


```BASH
canu -p nano -d nano genomeSize=5m useGrid=false -nanopore nanopore.fasta
```










```BASH
create_fragment_bed.bash --reference hg38-mhc.fa --min_length 400 --max_length 500 --count 50000 --output illumina.bed.gz

bedtools getfasta -fi hg38-mhc.fa -bed illumina.bed.gz -fo illumina.exact.fasta

add_error_to_fragments.bash --percent 1 ... illumina.exact.fasta

fragments_to_paired_end.bash ... illumina.exact.fasta
```





Create a config.txt file

```BASH
masurca_install_path/bin/masurca config.txt
assemble.sh
```



