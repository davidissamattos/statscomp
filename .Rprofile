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
# ggplot2::theme_replace(axis.title.y=element_blank())
# ggplot2::theme_replace(axis.text.y=element_text(size=8, angle = 90))
ggplot2::theme_replace(axis.title.y=element_text(size=10, angle=90))
ggplot2::theme_replace(axis.title.x=element_text(size=10))
ggplot2::theme(plot.title=element_text(face="plain", size=12))
#others
library(progress)
library(gtools)

#sourcing local files
source("utils.R")
#apparently this solves some of the problems with stna??
Sys.unsetenv("PKG_CXXFLAGS")


knitr::opts_chunk$set(
  echo=T, 
  warning=FALSE, 
  include=T,
  cache=T,
  prompt=FALSE,
  tidy=FALSE,
  comment=NA,
  message=FALSE,
  fig.align='center')
knitr::opts_knit$set(width=75)
