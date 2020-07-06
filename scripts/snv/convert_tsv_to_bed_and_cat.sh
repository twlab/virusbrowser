# Jennifer Flynn jaflynn@wustl.edu
# Feb 5, 2020
# This script takes in a .tsv file with 3 columns (mismatch, insertion, and deletion), and converts the data into a bed file for browser upload and a categorical file for browser upload, both zipped.

# To run this script, run: bash convert_tsv_to_bed.sh <tsv file> <output cat file> <output bed file> <reference>

# Read in the arguments
input_file=$1
output_bed_file=$2
output_cat_file=$3
reference=$4

# Remove the header from the file
tail -n +2 $input_file > $output_bed_file".temp"

# Create a bed file with mutation type and nucleotide change	
awk -F'\t' -v var=$reference '{OFS="\t"; if ($1 && $2=="" && $3=="") {print var, NR-1, NR, "mismatch: "$1} else if ($1=="" && $2 && $3=="") {print var, NR-1, NR, "insertion: "$2} else if ($1=="" && $2=="" && $3) {print var, NR-1, NR, "deletion: "$3} else if ($1 && $2 && $3=="") {print var, NR-1, NR, "mismatch and insertion: "$1"/"$2}}' $output_bed_file".temp" > $output_bed_file".bed.temp"
sort -k1,1 -k2,2n $output_bed_file".bed.temp" > $output_bed_file
bash `dirname "$0"`/merge_deletion.sh $output_bed_file
bgzip $output_bed_file
tabix -p bed $output_bed_file".gz"

# Create a categorical track file
# awk -F'\t' -v var=$reference '{OFS="\t"; if ($1=="A" && $2=="" && $3=="") {print var, NR-1, NR, 1} else if ($1=="T" && $2=="" && $3=="") {print var, NR-1, NR, 2} else if ($1=="G" && $2=="" && $3=="") {print var, NR-1, NR, 4} else if ($1=="C" && $2=="" && $3=="") {print var, NR-1, NR, 3} else if ($1=="" && $2 && $3=="") {print var, NR-1, NR, $2} else if ($1=="" && $2=="" && $3) {print var, NR-1, NR, 6} else if ($1 && $2 && $3=="") {print var, NR-1, NR, $1"/"$2}}' $output_bed_file".temp" > $output_cat_file".temp"
# sort -k1,1 -k2,2n $output_cat_file".temp" > $output_cat_file
# bgzip $output_cat_file
# tabix -p bed $output_cat_file".gz"

# Remove the temp files
rm $output_bed_file".temp"
rm $output_bed_file".bed.temp"
# rm $output_cat_file".temp"
