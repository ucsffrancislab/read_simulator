#!/usr/bin/env bash

set -e	#	exit if any command fails
set -u	#	Error on usage of unset variables
set -o pipefail

#set -x

script=$( basename $0 )

#ARGS=$*

function usage(){
	echo
	echo "Usage: (NO EQUALS SIGNS)"
	echo
	echo "$script [--reference STRING] [--length INTEGER] [--output STRING]"
	echo
	echo "Defaults:"
#	echo "  human ..... : $human"
#	echo "  viral ..... : $viral"
#	echo "  threads ... : $threads (for bowtie2)"
#	echo "  distance .. : $distance (for overlappers)"
	echo
	echo
	echo "Example:"
	echo "$script --reference hg38-mhc.fa --length 1000 --output illumina.bed"
	echo
	exit
}

#	Search for the output file
while [ $# -gt 0 ] ; do
	case $1 in
		--reference)
			shift; reference=$1; shift;;
		--count)
			shift; count=$1; shift;;
		--min_length)
			shift; min_length=$1; shift;;
		--max_length)
			shift; max_length=$1; shift;;
		--output)
			shift; output=$1; shift;;
#		-*)
#			echo ; echo "Unexpected args from: ${*}"; usage ;;
#		*)
#			break;;
		*)
			shift;;
	esac
done

#[ $# -eq 0 ] && usage

f="${output}"
if [ -f $f ] && [ ! -w $f ] ; then
	echo "Write-protected $f exists. Skipping."
else
	echo "Creating $f"
	rm -f $f

	sequence_count=$( cat ${reference}.fai | wc -l )
	echo "sequence count : ${sequence_count}"
	total_length=$( awk -F"\t" '{s+=$2}END{print s}' ${reference}.fai )

	echo "total length : ${total_length}"

	while read -r refchr reflength a b c ; do
		echo "chr : ${refchr}"
		echo "length : ${reflength}"

		chr_count=$(( ${count} * ${reflength} / ${total_length} ))
		echo ${chr_count}

		for i in $( seq -w ${chr_count} ) ; do

			#	The first three required BED fields are:
			#	
			#	chrom - The name of the chromosome (e.g. chr3, chrY, chr2_random) or scaffold (e.g. scaffold10671).
			#	chromStart - The starting position of the feature in the chromosome or scaffold. The first base in a chromosome is numbered 0.
			#	chromEnd - The ending position of the feature in the chromosome or scaffold. The chromEnd base is not included in the display of the feature, however, the number in position format will be represented. For example, the first 100 bases of chromosome 1 are defined as chrom=1, chromStart=0, chromEnd=100, and span the bases numbered 0-99 in our software (not 0-100), but will represent the position notation chr1:1-100. Read more here.
			#	The 9 additional optional BED fields are:
			#	
			#	name - Defines the name of the BED line. This label is displayed to the left of the BED line in the Genome Browser window when the track is open to full display mode or directly to the left of the item in pack mode.
		

			#	randomly select length
			#	randomly select central position
			#	trim excess over beginning or end

			position=$( shuf -i 0-${reflength} -n 1 )
			length=$( shuf -i ${min_length}-${max_length} -n 1 )
			cstart=$(( ${position} - ( ${length}/2 ) - 1 ))
			[ ${cstart} -lt 0 ] && cstart=0
			cend=$(( ${position} + ( ${length}/2 ) ))
			[ ${cend} -gt ${reflength} ] && cend=${reflength}

			echo "${refchr}	${cstart}	${cend}	${refchr}seq${i}" >> $f

		done

	done < ${reference}.fai

	if [ ${f:(-3)} == '.gz' ] ; then
		mv ${f} ${f%.gz}
		gzip --best ${f%.gz}
	fi
	chmod a-w $f
fi

