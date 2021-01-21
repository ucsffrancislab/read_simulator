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

