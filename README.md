# Nextflow RNAseq in SOMMA

Code to use the nextflow rnaseq pipeline for data preprocessing of SOMMA bulk RNAseq data from muscle.

Documentation describes installation of nextflow and download of reference genomes, creating a sample sheet from files in batches, running nextflow STAR-salmon branch on HPC with output of BAM files, duplicate removal and BAM concatenation, transcript quantification with Salmon, and import into R for gene-based abundance analysis.

1. Installation

Introduction to [NF](https://nf-co.re/docs/usage/getting_started/introduction)

## Nextflow install

Navigate to directory to store docker containers. Does not need to be in path.

module load openjdk			# load newer java version 

java -version                           # Check that Java v11+ is installed

curl -s https://get.nextflow.io | bash  # Download Nextflow

chmod +x nextflow                       # Make executable

mv nextflow ~/bin/                      # Add to user's $PATH

After the curl command, the nextflow executable and .nextflow directory will be in your directory. The nextflow global config file is here .nextflow/config

## Nextflow configuration

Navigate to your download location.

cd .nextflow/

printf 'process.executor = "sge"\nprocess.penv = "smp"\nprocess.clusterOptions = "-S /bin/bash"' > .nextflow/config

nextflow run nf-core/rnaseq -profile test,singularity --outdir ~/myoutput


## Directory structure

```
|-RNAseq_nf
|-data
|  |-aux_files
|  |-fastq
|    |-batch1
|    |-batch7
|-nf
|  |-save_refgenome
|  |-batch7_index
|  |-batch7

```

## Create samplesheet

run samp_sheet.R

Do this for each batch separately

## Run NF

nf_code_index.txt

nf_code_process.txt




 
