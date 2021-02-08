#####
## Extended Axiomatic Design   // 2020-01-02   V 1.00


# install.packages(c(
#    "dplyr",
#    "tidyr",
#    "rmarkdown",
#    "ggplot2",
#    "igraph",
#    "visNetwork",
#    "data.tree",
#    "plot.matrix",
#    'doParallel',
#    'doSNOW'
# 
#  ))
# # 
# Packages <- c("dplyr", "ggplot2", "rmarkdown", "tidyr", "igraph","data.tree", "reshape2",'visNetwork','plot.matrix','doParallel','doSNOW')
# lapply(Packages, library, character.only = TRUE)

## 0 - Install librairies - Library


#install.packages('matlib')
# install.packages('doParallel')
library('doParallel')
library('doSNOW')
# library('dplyr')

##############################
# 1 - Start

## SOURCE THIS FILE FOR EXECUTION
 
# subfunction
source("src/.systemcache/.designfunctions.R")
source("src/.systemcache/.auxiliar_functions.R")

# execution functions
source("src/1_gen_EAD.R")
source("src/2_calc_EAD.R")
 
source("src/1.1_set_EconomicParameters.R")
source("src/.economicparameters/.set_Demand.R")
source("src/.economicparameters/.set_ResourcePrices.R")

source("src/1.2_define_ProductPortfolio.R") 
source("src/.productportfolio/.define_MarketandCustomers.R")
source("src/.productportfolio/.define_Products.R")
 
source("src/1.3_design_ProductFamilies.R")

source("src/1.4_build_ProductionTechnology.R") 
source("src/.productiontechnology/.build_COST_CONS_PAT.R")
source("src/.productiontechnology/.build_RES_CONS_PAT.R")

#add-ons
source("src/addons/.EAD_example.R")
source("src/addons/.modularize.R")
source("src/addons/.networkvisualization.R")

source("01 INIT.R") 
