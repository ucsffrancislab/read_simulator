#!/usr/bin/env bash


mkdir test
for suffix in a b c ; do

	create_fragment_bed.bash --reference hg38-mhc.fa \
		--min_length 1000 --max_length 15000 --count 10000 --output test/exact.10x1-15${suffix}.bed.gz
	bedtools getfasta -name -fi hg38-mhc.fa \
		-bed test/exact.10x1-15${suffix}.bed.gz -fo test/exact.10x1-15${suffix}.fasta

	create_fragment_bed.bash --reference hg38-mhc.fa \
		--min_length 5000 --max_length 15000 --count 10000 --output test/exact.10x5-15${suffix}.bed.gz
	bedtools getfasta -name -fi hg38-mhc.fa \
		-bed test/exact.10x5-15${suffix}.bed.gz -fo test/exact.10x5-15${suffix}.fasta

	create_fragment_bed.bash --reference hg38-mhc.fa \
		--min_length 5000 --max_length 50000 --count 10000 --output test/exact.10x5-50${suffix}.bed.gz
	bedtools getfasta -name -fi hg38-mhc.fa \
		-bed test/exact.10x5-50${suffix}.bed.gz -fo test/exact.10x5-50${suffix}.fasta

	create_fragment_bed.bash --reference hg38-mhc.fa \
		--min_length 10000 --max_length 50000 --count 10000 --output test/exact.10x10-50${suffix}.bed.gz
	bedtools getfasta -name -fi hg38-mhc.fa \
		-bed test/exact.10x10-50${suffix}.bed.gz -fo test/exact.10x10-50${suffix}.fasta

done

