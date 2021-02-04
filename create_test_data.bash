#!/usr/bin/env bash



#	cp /francislab/data1/refs/sources/hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.chr6.transcript.HLA.gtf ./
#	
#	bedtools getfasta -fi /francislab/data1/refs/fasta/hg38.fa -bed hg38.ncbiRefSeq.chr6.transcript.selectHLA.gtf -fo hg38.ncbiRefSeq.chr6.transcript.selectHLA.fa -name
#	
#	samtools faidx hg38.ncbiRefSeq.chr6.transcript.selectHLA.fa
#	
#	\rm hla.fa
#	
#	for x in $( cat hg38.ncbiRefSeq.chr6.transcript.selectHLA.fa.fai | awk '{print $1}' ) ; do
#	samtools faidx hg38.ncbiRefSeq.chr6.transcript.selectHLA.fa ${x} >> hla.fa
#	samtools faidx --reverse-complement hg38.ncbiRefSeq.chr6.transcript.selectHLA.fa ${x} >> hla.fa
#	done
#	sed -i '/^>.*[^\/rc]$/ s/$/\/fw/' hla.fa 
#	sed -i '/^>/ s/\//_/' hla.fa 
#	samtools faidx hla.fa


mkdir test
./create_fragment_bed.bash --outbase test/
for f in test/*bed.gz ; do
echo $f
bedtools getfasta -name -fi hla.fa -bed $f -fo ${f%.bed.gz}.fasta
done
chmod -w test/*fasta

mkdir test/assemble
for f in test/HLA-*_fw.fasta ; do
d=$(dirname ${f})
cp ${f} ${d}/assemble
b=${f%_fw.fasta}
cat ${b}_{fw,rc}.fasta > test/assemble/$( basename ${b} )_both.fasta
done
chmod -w test/assemble/*fasta

for f in test/assemble/*both.fasta ; do
echo $f
b=${f%.fasta}
add_error_to_fragments.bash --percent 10 ${f} > ${b}.10a.fasta
add_error_to_fragments.bash --percent 10 ${f} > ${b}.10b.fasta
add_error_to_fragments.bash --percent 10 ${f} > ${b}.10c.fasta
add_error_to_fragments.bash --percent 15 ${f} > ${b}.15a.fasta
add_error_to_fragments.bash --percent 15 ${f} > ${b}.15b.fasta
add_error_to_fragments.bash --percent 15 ${f} > ${b}.15c.fasta
done
chmod -w test/assemble/*fasta

