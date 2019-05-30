#!/bin/bash

# Usage: seq2c.sh sample2bam.txt bed control_samples
SH_DIR=`cd "$(dirname $0)"; pwd -P`
SAM2BAM=$1
BED=$2

CONTROL=$3  # Optional control sample names. For multiple controls, separate them using :
SEQ2COPT=$4

OPT=""
if [ $CONTROL ]
    then
    CONS="-c $CONTROL"
    OPT="-c"
fi

echo "Starts seq2cov.pl on $SAM2BAM"
cat $SAM2BAM | while read i; do a=(${i//\\t/}); $SH_DIR/seq2cov.pl -b ${a[1]} -N ${a[0]} $BED; done > cov.txt
echo "Starts bam2reads.pl"
$SH_DIR/bam2reads.pl $SAM2BAM > read_stats.txt

#echo cov2lr.pl -a $CONS read_stats.txt cov.txt lr2gene.pl $OPT
echo "Starts cov2lr.pl and lr2gene.pl"
$SH_DIR/cov2lr.pl -a $CONS read_stats.txt cov.txt | $SH_DIR/lr2gene.pl $OPT $SEQ2COPT > seq2c_results.txt
