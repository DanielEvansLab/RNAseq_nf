#2024-5-30
#Code I ran on the command line to download human genome fasta and gtf to use with nextflow for RNAseq preprocessing


#ran on 5-30-2024. Ensembl version 112 at that date
latest_release=$(curl -s 'http://rest.ensembl.org/info/software?content-type=application/json' | grep -o '"release":[0-9]*' | cut -d: -f2)

echo $latest_release #112
#Downloaded Ensembl release 112 of human genome GRCh38.p14 and gtf

cd ../data/aux_files/

wget -L ftp://ftp.ensembl.org/pub/release-${latest_release}/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz

wget -L ftp://ftp.ensembl.org/pub/release-${latest_release}/gtf/homo_sapiens/Homo_sapiens.GRCh38.${latest_release}.gtf.gz


