
# Custom color palette ----------------------------------------------------

hambi_colors <- c(`HAMBI_1287` = "#6DA3EE", `HAMBI_1977` = "#F1C82E", `HAMBI_0403` = "#FB8A5C", 
                  `HAMBI_2659` = "#624090", `HAMBI_1972` = "#26818E", `HAMBI_1292` = "#32702C", 
                  `HAMBI_1923` = "#FC2EDB", `HAMBI_1279` = "#FE1C35", `HAMBI_1299` = "#BEEF60", 
                  `HAMBI_1896` = "#1C26FB", `HAMBI_0097` = "#F0DACB", `HAMBI_1988` = "#D71C76", 
                  `HAMBI_0006` = "#870DAE", `HAMBI_2792` = "#0DFE32", `HAMBI_3031` = "#FC94D1", 
                  `HAMBI_2160` = "#16EEA5", `HAMBI_0105` = "#00F5F7", `HAMBI_3237` = "#956616", 
                  `HAMBI_2494` = "#DABBF3", `HAMBI_2164` = "#DF26FD", `HAMBI_0262` = "#8D324F", 
                  `HAMBI_2443` = "#9DE0C5", `HAMBI_2159` = "#92950D", `HAMBI_1842` = "#F489FD"
)

# Project paths -----------------------------------------------------------

data_sp <- here::here("data", "strep_only", "communities", "amplicon_sp_counts")
data_ds <- here::here("data", "strep_only", "communities", "cell_density")
data_ml <- here::here("data", "strep_only", "communities", "machine_learning_pipelines")
data_cl <- here::here("data", "strep_only", "monocultures", "clone_phenotyping")
figs <- here::here("figs", "strep_only")

data_stp_sp <- here::here("data", "strep_predator", "communities", "amplicon_sp_counts")
data_stp_ds <- here::here("data", "strep_predator", "communities", "cell_density")
data_stp_ml <- here::here("data", "strep_predator", "communities", "machine_learning_pipelines")
data_stp_cl <- here::here("data", "strep_predator", "monocultures", "clone_phenotyping")
figs_stp <- here::here("figs", "strep_predator")

# Functions ---------------------------------------------------------------

# # opposite of %in% fuction
# `%nin%` = Negate(`%in%`)
# 
# # logit transform
# logit = function(x){
#   log(x/(1-x))
# }
# 
# minnz = function(V) {
#     # Calculates the smallest value of the vector except for 0 (non-zero minumum)
#     # Argument: vector
#     C <- NULL        # prepare
#     k <- length(V)   # count to
#     for (i in 1:k) { # check all
#       if ((V[i] == 0) == FALSE) (C[i] <- V[i]) else (C[i] <- 9999919) # if V[i] is not 0, add it to C
#     }
#     m <- min(C)               # minimum of V, not counting 0
#     if (max(V) == 1) (m <- 1) # fix for binary vectors (0,1)
#     if (m == 9999919) (warning("Error: Minimum calculation failed."))  # warning because of hard-coded replacement
#     return(m)
#   }
# 
# quibble95 = function(x, q = c(0.025, 0.5, 0.975)) {
#   tibble::tibble(x = quantile(x, q), quantile = c("q2.5", "q50", "q97.5"))
# }