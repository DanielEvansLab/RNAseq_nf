#Create sample sheet for a batch

dir_base <- "~/bigdata/SOMMA/baseline/RNAseq/"
dir_in <- "data/fastq/batch7"   #do not include trailing slash
dir_out <- "nf/batch7_index/" 


library(tidyverse)

#Import file names
files_fastq <- list.files(path = paste0(dir_base, dir_in), pattern = "*.fastq.gz$", 
                          recursive = TRUE, full.names = TRUE)
sampleIDs <- str_extract(files_fastq, "SOMMA[0-9]+")
sum(duplicated(sampleIDs))
samp_sheet <- tibble(sample = sampleIDs, path = files_fastq, strandedness = "auto")

samp_sheet$path[1]
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 1)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 2)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 3)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 4)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 5)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 6)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 7) 
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 8) 
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 9)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 10)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 11)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 12)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 13)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 14)
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 15) #run, or folder containing paired reads
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 16) #file name
str_split_i(string = samp_sheet$path[1], pattern = "/", i = 17) 

run_lane <- str_split_i(string = samp_sheet$path[1], pattern = "/", i = 15)
run_lane
run <- str_extract(run_lane, pattern = "^GE[0-9]*")
run
run <- str_split_i(string = run_lane, pattern = "_", i = 1)
run
lane <- str_extract(run_lane, pattern = "L[0-9]*$")
run_lane
run
lane

#Create Nextflow sample sheet

#convert bytes to GB for file size

samp_sheet <- samp_sheet %>%
  mutate(run_lane = str_split_i(path, pattern = "/", i = 15),
         fastq_fname = str_split_i(path, pattern = "/", i = 16),
         filesize_GB = file.size(path)/1e9)
samp_sheet <- samp_sheet %>%
  mutate(run = str_split_i(run_lane, pattern = "_", i = 1),
         lane = str_extract(run_lane, pattern = "L[0-9]*$"))
samp_sheet <- samp_sheet %>%
  mutate(sampleID = paste(sample, run, lane, sep = "_"))

samp_sheet %>%
  arrange(desc(filesize_GB))

samp_sheet %>%
  arrange(filesize_GB)

#filter row for _R1_ and _R2_ and then merge 2 DFs
samp_sheet %>%
  group_by(sample, run_lane) %>%
  tally(sort = TRUE)

samp_sheet %>%
  group_by(sample, run_lane) %>%
  tally() %>%
  filter(n > 2)

samp_sheetR1 <- samp_sheet %>%
  filter(str_detect(fastq_fname, pattern = "_R1_")) %>%
  rename(fastq_1=path)

samp_sheetR2 <- samp_sheet %>%
  filter(str_detect(fastq_fname, pattern = "_R2_")) %>%
  rename(fastq_2=path)

sum(duplicated(samp_sheetR1$sampleID))
sum(duplicated(samp_sheetR2$sampleID))

samp_sheet_out <- samp_sheetR1 %>%
  inner_join(samp_sheetR2, by = "sampleID") %>%
  mutate(strandedness = "auto") 

sum(duplicated(samp_sheet_out$sampleID))

#Can choose to limit the sample sheet to a smaller number of samples
myIDsmall <- samp_sheet_out %>%
  arrange(filesize_GB.x) %>%
  slice_head(n = 1) %>%
  pull(sampleID)

samp_sheet_out %>%
  filter(sampleID %in% myIDsmall) %>%
  select(sample = sample.x, sampleID, GB_read1 = filesize_GB.x, GB_read2 = filesize_GB.y)

samp_sheet_nf <- samp_sheet_out %>%
  filter(sampleID %in% myIDsmall) %>%
  select(sample = sampleID, fastq_1, fastq_2, strandedness) %>%
  arrange(sample)

write_csv(samp_sheet_nf, file = paste0(dir_base, dir_out, "samplesheet.csv"))


