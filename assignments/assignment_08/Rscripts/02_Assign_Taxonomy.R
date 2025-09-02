# SETUP ####

# SETUP ####

# Tell R which working directory it should be in (change if necessary)
setwd("~/Desktop/GIT_REPOSITORIES/BIOCOMPUTING/assignments/assignment_8")
# setwd("~/BIOCOMPUTING/assignments/assignment_8")

## packages ####
library(readr)
library(tidyr)
library(dplyr)
library(stringr)
library(dada2)
library(decontam)

## functions ####
source("./Rscripts/functions.R")

## load metadata ####
meta <- read_csv("./data/metadata/sporosphere_metadata.csv")

# get taxonomy database files
genus_db <- "./taxonomy/silva_nr99_v138.2_toGenus_trainset.fa.gz"

# get possible asv table files
asv_tables <- list.files("./data/asv_tables",full.names = TRUE,pattern = "_ASV_Table.RDS")
asv <- readRDS(asv_tables)

# remove ASVs that don't have at least 100 observations
asv_thinned <- asv[,which(colSums(asv) >= 100)]


if(file.exists(genus_db)){
      outfile <- str_replace(asv_tables,"_ASV","_genus_Taxonomy")
      
      tax_genus <- assign_taxonomy_to_asv_table(asv.table=asv_thinned,
                                          tax.database=genus_db,
                                          multithread=parallel::detectCores(),
                                          random.seed=666,
                                          try.rc = FALSE,
                                          min.boot=70)
      # export as RDS
      saveRDS(tax_genus,outfile)
      
    } else {warning("Genus Taxonomic database does not exist as specified.")}
