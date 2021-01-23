#!/usr/bin/env bash

percent=10

while [ $# -ne 0 ] ; do
	#	Options MUST start with - or --.
	case $1 in
		-p*|--p*)
			shift; percecnt=$1; shift ;;
		--)	#	just -- is a common and explicit "stop parsing options" option
			shift; break ;;
		-*)
			echo ; echo "Unexpected args from: ${*}"; usage ;;
		*)
			break;;
	esac
done




awk -v percent=${percent} 'BEGIN{
	srand()
	split("ACTG",nt,"")
}
($0 ~/^>/){print}
($0 !~/^>/){
	split($0,a,"")
	for(i=1;i<=int(percent*length($0)/100);i++)
		a[1+int(rand()*length($0))]=nt[1+int(rand()*4)]
	s=""
	for(i=1;i<=length($0);i++)
		s=s a[i]
	print s
}' $1


