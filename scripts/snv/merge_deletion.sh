#!/bin/bash
# $1: input unmerged files
cat $1 | awk -F "\t" 'BEGIN {OFS="\t"; r=-1} {if ( (($3 - r) == 1 ) && ($4 ~ /deletion.*/) ) $2=$2-1; if ($4 ~ /deletion.*/) r=$3; print $0}' | \
bedtools merge -i stdin -d -1 -c 4 -o collapse | awk -F "\t" 'BEGIN{OFS="\t"} {if ($4 ~/deletion.+,.+/) {$4=gensub(/deletion/, "", "g", $4);\
$4 = gensub(/ /, "", "g", $4); $4 = gensub(/[,:]/, "", "g", $4); $4="deletion: "$4}; print $0 }' > $1.t
mv $1.t $1