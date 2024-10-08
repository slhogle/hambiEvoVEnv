library(here)
library(tidyverse)
library(phyloseq)

# Read data ---------------------------------------------------------------

counts_metadata <- read_tsv(here("data", "amplicon", "amplicon_metadata.tsv")) %>%
  mutate(sample_time_wks = case_when(sample_time == "T0" ~ 0,
                                     sample_time == "T1" ~ 4,
                                     sample_time == "T2" ~ 8,
                                     sample_time == "T3" ~ 12))

OD <- read_tsv(here::here("data", "cell_density", "OD600.tsv")) 

tetra <- read_tsv(here::here("data", "cell_density", "tetrahymena.tsv")) 

counts <- read_rds(here::here("data", "amplicon", "corrected_species_counts.rds"))

otu_full <- left_join(counts, counts_metadata) %>%
  left_join(., OD) %>%
  left_join(., tetra)

# make otu matrix
otumat <- otu_full %>%
  dplyr::select(sample, strainID, count) %>%
  arrange(sample) %>%
  pivot_wider(names_from=sample, values_from=count) %>%
  column_to_rownames(var="strainID") %>%
  as.matrix()

taxmat <- counts %>% 
  dplyr::select(strainID, Genus=genus, Species=species) %>%
  distinct(strainID, Genus, Species) %>%
  column_to_rownames(var="strainID") %>%
  as.matrix()

metadf <- otu_full %>%
  dplyr::select(sample, treatment, LTCSE_history, replicate, sample_time_wks, OD_600, tetra_per_ml) %>%
  mutate(treatment = factor(treatment, levels = c("none", "bact", "bact_pred", "bact_strep", "bact_pred_strep")),
         LTCSE_history = factor(LTCSE_history, levels = c("anc", "bact", "bact_pred", "bact_strep", "bact_pred_strep")),
         replicate = factor(replicate, levels = c("A", "B", "C", "D", "E", "F")),
         sample_time_wks = factor(sample_time_wks, levels = c(0, 4, 8, 12))) %>%
  mutate(treat_hist = interaction(treatment, LTCSE_history, sep="_")) %>%
  arrange(sample) %>%
  distinct()

write_rds(metadf, here::here("data", "amplicon", "amplicon_metadata_formatted.rds"))

physeq <- phyloseq(otu_table(otumat, taxa_are_rows = TRUE), 
                   tax_table(taxmat),
                   sample_data(column_to_rownames(metadf, var = "sample")))

write_rds(physeq, here::here("data", "amplicon", "physeq.rds"))
