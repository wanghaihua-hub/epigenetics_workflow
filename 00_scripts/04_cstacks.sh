#!/bin/bash
# Lauch cstacks on all the .tags.tsv files
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)

# Copy script as it was run
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"

cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Options
# Comment out options that you do not wish to use

b="-b 1"            # b: MySQL ID of this batch
o="-o 03_trimmed"    # o: output path to write results
#g="-g"             # g: base catalog matching on genomic location, not sequence
                    #   identity
#m="-m"             # m: include tags in catalog that match more than one entry
n="-n 0"            # n: number of mismatches allowed between sample tags when
                    #   generating the catalog (default 0)
p="-p 5"           # p: enable parallel execution with num_threads threads

#Catalog editing:
#catalog="--catalog PATH"   # provide the path to an existing catalog. cstacks will add data to this existing catalog.

#Advanced options:

#k_len="--k_len 31"                      # specify k-mer size for matching between catalog loci (automatically calculated by default).
#report_mmatches="--report_mmatches "    # report query loci that match more than one catalog locus


# -=( DO NOT MODIFY THE FOLLWING OPTION! )=-
# This will automatically create the list of filenames for cstacks
# s: filename prefix from which to load loci into the catalog
s="$(for file in $(ls -1 03_trimmed/*.tags.tsv.gz | perl -pe 's/\.tags\.tsv\.gz//'); do echo -s $file; done)"

# Run cstacks
cstacks $b $s $o $g $m $n $p $catalog $k_len $report_mmatches 2>&1 | tee 98_log_files/"$TIMESTAMP"_cstacks.log

