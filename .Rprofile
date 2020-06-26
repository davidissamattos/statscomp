source("renv/activate.R")
#rmarkdown
library(knitr)
library(rmdformats)
library(kableExtra)
#data processing
library(tidyverse)
library(glue)
#modeling
library(rstan)
options(mc.cores = parallel::detectCores()) #use multiple cores
rstan_options(auto_write = TRUE) # we dont need to recompile
library(coda)
#plotting
library(patchwork)
library(viridis)
library(ggthemr)#devtools::install_github('cttobin/ggthemr')
ggthemr('flat')
ggplot2::theme_replace(axis.text.y = element_text(angle = 45))
ggplot2::theme_replace(axis.title.y=element_blank())
#others
library(progress)
library(gtools)

#sourcing local files
source("utils.R")
#apparently this solves some of the problems with stna??
Sys.unsetenv("PKG_CXXFLAGS")
