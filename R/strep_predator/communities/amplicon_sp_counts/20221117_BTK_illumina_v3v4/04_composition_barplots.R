library(here)
library(tidyverse)
library(Polychrome)
library(withr)
library(patchwork)

source(here::here("R", "utils_generic.R"))

# Read data ---------------------------------------------------------------
counts <- read_rds(here::here("data", "amplicon", "corrected_species_counts.rds"))
expdesign <- readr::read_tsv(here::here("data", "amplicon", "amplicon_metadata.tsv"))

counts_f <- left_join(counts, expdesign) %>%
  group_by(sample) %>%
  mutate(f=count_correct/sum(count_correct)) %>%
  ungroup()

strain_order <- counts_f %>%
  group_by(strainID) %>%
  summarize(tot=sum(count_correct)) %>%
  arrange(tot) %>%
  pull(strainID)

# Strain colors -----------------------------------------------------------
counts_f <- counts_f %>%
  mutate(strainID=factor(strainID, levels=strain_order))

with_seed(1236,
          firstpal <- unname(createPalette(23, c("#F3874AFF", "#FCD125FF"), M=5000)))

names(firstpal) <- strain_order

#swatch(firstpal)

# Plot --------------------------------------------------------------------

# plot funs
mybartheme <- function(){
  theme(
    panel.spacing.x = unit(0,"line"),
    strip.placement = 'outside',
    strip.background.x = element_blank(),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    #axis.text.x = element_blank(),
    axis.line.x = element_line(color = "black"),
    axis.line.y = element_line(color = "black"),
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.key = element_blank())
}

mybarplot <- function(.data){
  title <- paste(unique(.data$LTCSE_history), unique(.data$sample_time))
  ggplot(.data) +
    geom_bar(aes(y = f, x=replicate, fill = strainID), 
             color="black", linewidth=0.25, stat="identity") +
    facet_grid(. ~ treatment, switch = "x") +
    scale_fill_manual(values = firstpal) + 
    scale_y_continuous(limits = c(0,1), expand = c(0, 0)) +
    labs(x="", y="% abundance", fill="", title=title) + 
    theme_bw() + 
    mybartheme()
}

# format, split by groups, then map to barplot function
a <- counts_f %>%
  # this can reformat the treatment syntax to include "match" category when treatment
  # matches the conditions in the LTCSE
  # mutate(treatment = ifelse(LTCSE_history == treatment, "match", treatment)) %>%
  # mutate(treatment = factor(treatment,
  #                           levels = c("none", "match", "bact", "bact_strep", "bact_pred", "bact_pred_strep"),
  #                           labels = c("None", "Match", "B", "BS", "BT", "BTS"))) %>%
  mutate(treatment = factor(treatment,
                            levels = c("none", "bact", "bact_strep", "bact_pred", "bact_pred_strep"),
                            labels = c("None", "B", "BS", "BT", "BTS"))) %>%
  mutate(LTCSE_history=factor(LTCSE_history,
                              levels = c("anc", "bact", "bact_strep", "bact_pred", "bact_pred_strep"),
                              labels = c("Anc", "B", "BS", "BT", "BTS"))) %>%
  mutate(sample_time=factor(sample_time, levels = c("T0", "T1", "T2", "T3"))) %>%
  group_by(LTCSE_history, sample_time) %>%
  group_split() %>%
  map(mybarplot)

# wrap plots for a final figure
p <- wrap_plots(a) +
  plot_layout(guides = 'collect', 
              nrow=5,
              ncol=4,
              widths = c(0.25, 1, 1, 1, 1))

ggsave(here::here("figs", "amplicon", "species_comp.png"), p, width=12.5, height=11, units="in",
       device="png", dpi=320)
