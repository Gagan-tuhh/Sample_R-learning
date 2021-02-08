## EXTENDED AXIOMATIC DESIGN ####
#### V. 1.00 - Stablized; Runable for many settings; 
#### V. 1.1  - Stablized; Runable for all settings; New Modularization approaches.
#### V. 1.2  - Decoupling Market and Products; 


EAD = list()                           
DATA = data.frame()

## =====INPUT PARAMETERS ===========
##SIMULATION/OUTPUT SETTINGS
SIM_NUMB =        1    #Control Variable - Number of Simulations for every single environment (standard: 30)
modularization = FALSE                      # 0 = No modularization, 1 = modularization using the specified function
productOutput = TRUE         #TRUE = Output Data per product
check_measure = FALSE

#GLOABL
TC =               c(1000)  #Total costs
TQ =               c(100)    #Total demand

#CASE
case = c(8)          # 0 no example #1 case bottler #2 MCU 



#DOMAIN SIZES
NUMB_C =  c(3)      # Number of customers (customer segment)
NUMB_CN = c(3)       # Number of customers needs
NUMB_FR = c(10)       # Number of functional requirements (specifications)
NUMB_CM = c(10)   #Set the number of components
NUMB_AV = c(20)     # Number of activity variables (process)
NUMB_RC = c(20)     # Number of resources (capacities)
NUMB_P = c(3)       # Number of products

#DENSITY PARAMETER VALUES
#DENS = 0 <- diag. matrix
# 0 < DENS < 1 --> User defined density 
#DENS = -1 --> Random DENS with user defined boundaries (e.g. [0.4;0.7])
DENS_CCN = c(-1)  # Mapping between customer segments and customer needs
DENS_CNFR = c(-1) # Mapping between customer needs and functional requirements
DENS_FRCM = c(-1) # Mapping between functional requirements and components (product architecture)
DENS_CMAV = c(-1) # Mapping between components and activities
DENS_AVRC = c(-1) # Mapping between activities and resources
DENS_PFR = c(-1)  # Mapping between products and functional requirements (product similiarity for customers)
DENS_PCM = c(-1)  # Mapping between products and components (product similarity for the firm)

#ECONOMIC PARAMETER SETTINGS
Q_VAR = c(-1)         #Demand variation
RCU_VAR = c(-1)       #Resource cost variation;
UL_COST = c(-1)       #Share of unit-level costs
UL_RES = c(-1)        #Share of unit-level resources

## ==================== DESIGN OF EXPERIMENTS ============================= 

set.seed(13) #Reproducibility
runs = c(1:SIM_NUMB)
factorial_design = data.frame(expand.grid(runs,TC,TQ,NUMB_C,NUMB_CN,NUMB_FR,NUMB_CM,NUMB_AV,NUMB_RC,NUMB_P,
                               case,DENS_CCN,DENS_CNFR,DENS_FRCM,DENS_CMAV,DENS_AVRC,Q_VAR,RCU_VAR,UL_COST,UL_RES,DENS_PFR,DENS_PCM))

colnames(factorial_design) = c('runs','TC','TQ','NUMB_C','NUMB_CN','NUMB_FR','NUMB_CM','NUMB_AV','NUMB_RC','NUMB_P',
                               'case','DENS_CCN','DENS_CNFR','DENS_FRCM','DENS_CMAV','DENS_AVRC','Q_VAR','RCU_VAR','UL_COST','UL_RES','DENS_PFR','DENS_PCM')

## ==== MULTICORE SETTING ===========
cores=detectCores()
cl <- makeCluster(cores[1]-1)
registerDoSNOW(cl)
iterations <- nrow(factorial_design)
pb <- txtProgressBar(max = iterations, style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)

## ======== SIMULATION =========
DATA <- foreach(i = 1:nrow(factorial_design), .combine = rbind, .options.snow = opts) %do% {     #%dopar% -> %do% for debugging and browser() usage !!


    ## ======== PREDETERMINING AND PREALLOCATION ==========          
    o = factorial_design$runs[i]
    TC = factorial_design$TC[i]
    TQ = factorial_design$TQ[i]
    EAD$NUMB_C = factorial_design$NUMB_C[i]
    EAD$NUMB_CN = factorial_design$NUMB_CN[i]
    EAD$NUMB_FR = factorial_design$NUMB_FR[i]
    EAD$NUMB_CM = factorial_design$NUMB_CM[i]
    EAD$NUMB_AV = factorial_design$NUMB_AV[i]
    EAD$NUMB_RC = factorial_design$NUMB_RC[i]
    EAD$NUMB_P = factorial_design$NUMB_P[i]
    EAD$DENS_CCN = factorial_design$DENS_CCN[i]
    EAD$DENS_CNFR = factorial_design$DENS_CNFR[i] 
    EAD$DENS_FRCM = factorial_design$DENS_FRCM[i]   
    EAD$DENS_CMAV = factorial_design$DENS_CMAV[i]  
    EAD$DENS_AVRC = factorial_design$DENS_AVRC[i]
    EAD$DENS_PFR = factorial_design$DENS_PFR[i]
    EAD$DENS_PCM = factorial_design$DENS_PCM[i]
    EAD$Q_VAR = factorial_design$Q_VAR[i]
    EAD$RCU_VAR = factorial_design$RCU_VAR[i]
    EAD$UL_COST = factorial_design$UL_COST[i]
    EAD$UL_RES = factorial_design$UL_RES[i]
    EAD$case = factorial_design$case[i]

    ## ======== PROCESSING ==========   
    

    
    # COMPUTING THE BENCHMARK PRODUCT PROGRAM PLAN THROUGH THE EAD
   
    EAD = gen_EAD(EAD,TQ,TC)
    
    # COMPUTING DEMAND
    
    if(case == 8){
      
      EAD = .set_Demand(Newsvendor_D, Newsvendor_sd, Newsvendor_p, Newsvendor_c, Newsvendor_s)
    }
    
      else if(case == 8.1){
      EAD = .set_Demand_EOQ(EOQ_D, EOQ_S, EOQ_H, EOQ_b)
      }

      else if(case == 8.2){
      EAD = .set_Demand_EPQ(EPQ_D, EPQ_P, EPQ_K, EPQ_H)

    }
    
     # EAD = .set_Demand(Newsvendor_D, Newsvendor_sd, Newsvendor_p, Newsvendor_c, Newsvendor_s)
  
    

    ####EXTENSIONS###
    if(isTRUE(modularization)){EAD = .modularize(EAD,EAD$NUMB_CN,EAD$NUMB_C,EAD$TQ, method = "base")}    #base or martin-ishiix
    if(isTRUE(check_measure)){EAD =.check_measure(EAD)}

    ####END - EXTENSIONS###

    EAD = calc_EAD(EAD)
    
   
    
    #.plotigraph()
    #.plotigraph(EAD$A_CNFR,EAD$A_FRM,EAD$A_MAV,EAD$A_AVRC)
    #browser()
    #.visNetwork(EAD$A_CCN,EAD$A_CNFR,EAD$A_FRCM,EAD$A_CMAV,EAD$A_AVRC)
    #.visNetwork(EAD$A_CCN,EAD$A_CNFR,EAD$A_FRM,EAD$A_MAV,EAD$A_AVRC)

    ####DATALOGGING####
    if(isFALSE(productOutput)){
      TPC = sum(EAD$PCB) #Total portfolio costs
      tpc = sum(EAD$pcb) #unit portfolio costs

     preData = data.frame(o,case,EAD$NUMB_C, EAD$NUMB_CN, EAD$NUMB_FR, EAD$NUMB_CM, EAD$NUMB_AV, EAD$NUMB_RC,EAD$NUMB_P,
                           EAD$DENS_CCN, EAD$DENS_CNFR, EAD$DENS_FRCM, EAD$DENS_CMAV, EAD$DENS_AVRC,
                           EAD$Q_VAR_draw, EAD$RCU_VAR_draw,EAD$UL_COST,EAD$UL_COST_draw,EAD$UL_RES_draw,TPC,tpc,EAD$UCC)

      colnames(preData) = c('o','case','NUMB_C','NUMB_CN', "NUMB_FR", "NUMB_CM", "NUMB_AV", "NUMB_RC",'NUMB_P',
                            "DENS_CCN", "DENS_CNFR","DENS_FRCM","DENS_CMAV","DENS_AVRC",
                            "Q_VAR","RCU_VAR",'UL_COST','UL_COST_draw','UL_RES',"TPC",'tpc','UCC')

    }
    else if(isTRUE(productOutput)){
      NUMB_P = EAD$NUMB_P
      
      
      PRODUCT <-vector()
      case <- vector()
      NUMB_C<-vector()
      NUMB_CN<-vector()
      NUMB_FR<-vector()
      NUMB_CM<-vector()
      NUMB_AV<-vector()
      NUMB_RC<-vector()
      DENS_CCN<-vector()
      DENS_CNFR<-vector()
      DENS_FRCM<-vector()
      DENS_CMAV<-vector()
      DENS_AVRC<-vector()
      DENS_PFR<-vector()
      UCC <- vector()
      # Q = Newsvendor_Q
      Q <-vector()
      var_pcb <-vector()
      pcb <- vector()
      PCB <- vector()
      pcf <- vector()
      fci <- vector()
      
      PRODUCT <- c(PRODUCT, 1:NUMB_P) #How many products per run
      o[PRODUCT] <- o
      case[PRODUCT] = EAD$case
      NUMB_C[PRODUCT] = EAD$NUMB_C
      NUMB_CN[PRODUCT] = EAD$NUMB_CN
      NUMB_FR[PRODUCT] = EAD$NUMB_FR
      NUMB_CM[PRODUCT] = EAD$NUMB_CM
      NUMB_AV[PRODUCT] = EAD$NUMB_AV
      NUMB_RC[PRODUCT] = EAD$NUMB_RC
      DENS_CCN[PRODUCT]=EAD$DENS_CCN
      DENS_CNFR[PRODUCT]=EAD$DENS_CNFR
      DENS_FRCM[PRODUCT]=EAD$DENS_FRCM
      DENS_CMAV[PRODUCT]=EAD$DENS_CMAV
      DENS_AVRC[PRODUCT]=EAD$DENS_AVRC
      DENS_PFR[PRODUCT]=EAD$DENS_PFR
      UCC[PRODUCT] = EAD$UCC
      # Q[PRODUCT] = Newsvendor_Q
       Q[PRODUCT] = ceiling(EAD$DEMAND)
      var_pcb[PRODUCT] = EAD$var_pcb
      pcb[PRODUCT] =EAD$pcb
      PCB[PRODUCT] = EAD$PCB
      pcf[PRODUCT] = EAD$pcf
      fci[PRODUCT] = EAD$pcb/EAD$pcf
     
      preData = data.frame(o,case,PRODUCT,TQ,NUMB_C,NUMB_CN,NUMB_FR,NUMB_CM,NUMB_AV,NUMB_RC,
                           DENS_CCN,DENS_CNFR,DENS_FRCM,DENS_CMAV,DENS_AVRC,DENS_PFR,UCC,Q,var_pcb,pcb,PCB,pcf,fci)
      
    }
    
    ###OUTPUT####
    preData

}
close(pb)
stopCluster(cl)

## ==== OUTPUT WRITING ===================================

if(isFALSE(productOutput)){
  #output data
  output = paste("output/EAD_",format(Sys.time(),"%Y-%m-%d-%H%M"),".csv", sep = "")
  write.csv(DATA, file = output)
  print("FILE has been written")
}
if(isTRUE(productOutput)){
  #product output data
  output = paste("output/PRODUCT_EAD_",format(Sys.time(),"%Y-%m-%d-%H%M"),".csv", sep = "")
  write.csv(DATA, file = output)
  print("FILE has been written")
  
}




