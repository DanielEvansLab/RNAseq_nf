#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -l mem_free=30G
#$ -l h_rt=1:00:00

module load CBI
module load r
Rscript samp_sheet.R


