# Build Phyloseq Objects

# SETUP ####

# Tell R which working directory it should be in (change if necessary)
setwd("~/Desktop/GIT_REPOSITORIES/BIOCOMPUTING/assignments/assignment_8")
# setwd("~/BIOCOMPUTING/assignments/assignment_8")

## packages ####
library(readr)
library(tidyr)
library(dplyr)
library(dada2)
library(decontam)

## functions ####
source("./Rscripts/functions.R")

## load metadata ####
meta <- read_csv("./data/metadata/sporosphere_metadata.csv")

## data checks ####
if(any(!file.exists(meta$fwd_fp_raw))){
  warning("Some files not present in given paths. Check download. Subsetting to only present files.")
  meta <- meta[file.exists(meta$fwd_fp_raw),]
}  

if(!file.exists("./taxonomy/silva_nr99_v138.2_toGenus_trainset.fa.gz")){
  stop("Taxonomic databases not downloaded into correct path.")
}


# BUILD ASV TABLES ####

# create output directory for ASV table
dir.create("./data/asv_tables")

build_asv_table(metadata = meta,
                run.id.colname = "sra_bioproject",
                run.id = "PRJNA1276452",
                amplicon.colname = "amplicon",
                amplicon = "16S_V3V4",
                sampleid.colname = "sample_id",
                fwd.fp.colname = "fwd_fp_raw",
                rev.fp.colname = "rev_fp_raw",
                fwd.pattern = "_R1_",
                rev.pattern = "_R2_",maxEE = c(3,3),trim.right = 0,
                truncQ = 2,
                rm.phix = TRUE,
                compress = TRUE,
                multithread = (parallel::detectCores() -1),
                single.end = FALSE,
                filtered.dir = "filtered",
                asv.table.dir = "./data/asv_tables",
                control.col = "treatment",
                control.indicator = "negative_ctl",
                random.seed = 666)


