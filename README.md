
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











##	Masurca

If matched with Illumina short read data could use Masurca.

Create a config.txt file

```BASH
masurca_install_path/bin/masurca config.txt
assemble.sh
```

