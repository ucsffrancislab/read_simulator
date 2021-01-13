
#	Read Simulator


Create reads from a reference with added noise to test alignment strategies.


Tried [SiLiCO](https://github.com/ethanagbaker/SiLiCO) and [NanoSim](https://github.com/bcgsc/NanoSim). Looked into [Deep Simulator](https://github.com/liyu95/DeepSimulator) and [SimuSCoP](https://github.com/qasimyu/simuscop).

Need something much simpler.


Then try assembling with [Canu](https://canu.readthedocs.io/en/latest/index.html) or even [Masurca](http://masurca.blogspot.com/)


For example, I'd like to test assembling the HLA/MHC region.
This won't be perfect. I know that.


```BASH
samtools faidx hg38.fa chr6:28,510,120-33,480,577 > hg38-mhc.fa
```




Something like ...

```BASH
generate.bash paired --read_count 10000 --fragment_length 1000 --read_length 150 \
	--percent_error 1 --reference hg38-mhc.fa --outbase illumina

generate.bash single --read_count 10000 --min_read_length 500 --max_read_length 15000 \
	--percent_error 20 --reference hg38-mhc.fa --outbase nanopore
```


or like ...


```BASH
create_fragment_bed.bash --length 1000 --outbase illumina

bedtools getfasta hg38-mhc.fa illumina.bed illumina.exact.fasta

add_error_to_fragments.bash --percent 1 ... illumina.exact.fasta

fragments_to_paired_end.bash ... illumina.exact.fasta




create_fragment_bed.bash --min_length 500 --max_length 15000 --outbase nanopore

bedtools getfasta hg38-mhc.fa nanopore.bed nanopore.exact.fasta

add_error_to_fragments.bash --percent 20 nanopore.exact.fasta
```






```BASH
illumina_R1.fasta
illumina_R2.fasta

nanopore.fasta
```



```BASH
canu -p nano -d nano genomeSize=5m useGrid=false -nanopore nanopore.fasta
```




Create a config.txt file

```BASH
masurca_install_path/bin/masurca config.txt
assemble.sh
```



