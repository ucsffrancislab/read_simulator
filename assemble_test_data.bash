#!/usr/bin/env bash


for f in ${PWD}/test/assemble/*fasta ; do

	echo "Assembling ${f}"

	base=${f%.fasta}

	echo $base

	hla=$( basename $base )
	#hla=${hla%.*}
	hla=${hla%_*}
	echo $hla

	genomeSize=$( awk -v hla=${hla} '($1==hla"_fw"){print $2}' hla.fa.fai )
	echo $genomeSize

#	outdir=${base}.canu
#	mkdir $outdir
#
#	sbatch --job-name=$(basename $base).canu  --time=480 --ntasks=8 --mem=30G --output=${base}.canu.stdout \
#		${PWD}/canu.bash genomeSize=${genomeSize} useGrid=false maxThreads=8 maxMemory=30G maxInputCoverage=1000 \
#			-p canu -d ${outdir} -nanopore ${f}

	outdir=${base}.flye
	mkdir $outdir

	sbatch --job-name=$(basename $base).flye  --time=480 --ntasks=8 --mem=30G --output=${base}.flye.stdout \
		${PWD}/flye.bash --genome-size ${genomeSize} --threads 8 \
			--nano-corr ${f} --out-dir ${outdir}
#			--subassemblies ${f} --out-dir ${outdir}


#	
#		#	need a canu wrapper as the script expects other things to be relative to its location.
#		#sbatch --parsable --ntasks=8 --mem=8G --output=${outdir}/stdout \
#		#	120 minutes works for the 1-15 and 5-15 but not the 5-50 or 10-50
#		sbatch --job-name=$(basename $base)  --time=480 --ntasks=8 --mem=8G --output=${outdir}/stdout \
#			${PWD}/canu.bash genomeSize=5m useGrid=false correctedErrorRate=0.1 \
#				maxThreads=8 maxMemory=8G \
#				-p canu -d ${outdir} -corrected -trimmed -nanopore ${f}
#	
#	#	may be a default time limit of 10 minutes which will be too short.
#		
#	#	canu -options
#	#maxMemory                               Maximum memory to use by any component of the assembler
#	#maxThreads                              Maximum number of compute threads to use by any component of the assembler
#	
#		#nohup shasta --input nanopore.exact.fasta --assemblyDirectory shasta > shasta.out &
#		#nohup shasta --input nanopore.exact.fasta --Reads.minReadLength 1000 --assemblyDirectory shasta1000 > shasta1000.out &
#		#nohup shasta --input nanopore.large.exact.fasta --assemblyDirectory shasta.large > shasta.large.out &
#		#
#		#nohup shasta --config Nanopore-Sep2020.conf --input nanopore.exact.fasta --assemblyDirectory shastaconf > shastaconf.out &
#		#nohup shasta --config Nanopore-Sep2020.conf --input nanopore.large.exact.fasta --assemblyDirectory shastaconf.large > shastaconf.large.out &
#		#
#		#nohup flye --genome-size 5m --threads 8 --nano-cor nanopore.exact.fasta --out-dir flye.dir > flye.out 2> flye.err &
#		#nohup flye --genome-size 5m --threads 8 --nano-cor nanopore.large.exact.fasta --out-dir flye.large.dir > flye.large.out 2> flye.large.err &
#		#
#		#/bin/rm -rf flye.dir flye.out flye.err flye.large.dir flye.large.out flye.large.err
#		#nohup flye --genome-size 5m --threads 8 --subassemblies nanopore.exact.fasta --out-dir flye.dir > flye.out 2> flye.err &
#		#nohup flye --genome-size 5m --threads 8 --subassemblies nanopore.large.exact.fasta --out-dir flye.large.dir > flye.large.out 2> flye.large.err &
#	
#	
#		#Shasta Defaults
#		#--Reads.minReadLength 10000
#		#--Kmers.k 10
#		#--MinHash.minBucketSize 0
#		#--MinHash.maxBucketSize 10
#		#--MinHash.minFrequency 2
#		#--Align.alignMethod 3
#		#--Align.downsamplingFactor 0.10000000000000001
#		#--Align.matchScore 6
#		#--Align.sameChannelReadAlignment.suppressDeltaThreshold 0
#		#--Align.maxSkip 30
#		#--Align.maxDrift 30
#		#--Align.maxTrim 30
#		#--Align.minAlignedMarkerCount 100
#		#--Align.minAlignedFraction 0
#		#--ReadGraph.creationMethod 0
#		#--MarkerGraph.simplifyMaxLength 10,100,1000
#		#--MarkerGraph.crossEdgeCoverageThreshold 0
#		#--MarkerGraph.minCoverage 10
#		#--Assembly.consensusCaller Bayesian:guppy-2.3.5-a
#		#--Assembly.detangleMethod 0
#		#
#		#Shasta Nanopore-Sep2020.conf
#		#--Reads.minReadLength 10000
#		#--Reads.noCache
#		#--Kmers.k 14
#		#--MinHash.minBucketSize 5
#		#--MinHash.maxBucketSize 30
#		#--MinHash.minFrequency 5
#		#--Align.alignMethod 3
#		#--Align.downsamplingFactor 0.05
#		#--Align.matchScore 6
#		#--Align.sameChannelReadAlignment.suppressDeltaThreshold 30
#		#--Align.maxSkip 100
#		#--Align.maxDrift 100
#		#--Align.maxTrim 100
#		#--Align.minAlignedMarkerCount 10
#		#--Align.minAlignedFraction 0.1
#		#--ReadGraph.creationMethod 2
#		#--MarkerGraph.simplifyMaxLength 10,100,1000,10000,100000
#		#--MarkerGraph.crossEdgeCoverageThreshold 3
#		#--MarkerGraph.minCoverage 0
#		#--Assembly.consensusCaller Bayesian:guppy-3.6.0-a
#		#--Assembly.detangleMethod 2
#	
#	

done
