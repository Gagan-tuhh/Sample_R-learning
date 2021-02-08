
#Calculating the costs of the EAD
calc_EAD <- function(EAD) {
 
#####
  # #0. create p_cm matrix
  # #0.1
  # if(sum(EAD$A_PCM)==0){
  #   A_PCM = matrix(nrow = EAD$NUMB_P, ncol = EAD$NUMB_CM)
  #   
  #   for(i in 1:nrow(EAD$A_PFR)){
  #     #define which frs are required
  #     req_fr = c(1:EAD$NUMB_FR)[rowSums(EAD$A_PFR[i,] * EAD$A_FRCM)>0]
  #     all_fr = as.numeric(c(1:EAD$NUMB_FR))
  #     not_req_fr = as.vector(all_fr[-req_fr])
  #     #define which cms are required based on the frs
  #     req_cm = as.numeric(which(colSums(EAD$A_FRCM[req_fr,])>0))
  #     A_PCM[i,req_cm]<-1
  #     for(j in 1:length(not_req_fr)){
  #       y = subset(melt(EAD$A_FRCM), Var1 == paste0("FR",not_req_fr[j]) & value >0)
  #       drop_cm = as.numeric(y$Var2)
  #       small_fr = as.numeric(which(rowSums(EAD$A_FRCM[,-drop_cm])==1))
  #       #drop all cms that fulfill frs that are not required
  #       A_PCM[i,drop_cm]<-0
  #       #check whether still all frs are fulfilled, if that is not the case look for missing frs
  #       if(length(setdiff(req_fr,small_fr))>0){
  #         missing_fr =setdiff(req_fr,small_fr)
  #         if(length(missing_fr)>1){
  #           for(s in 1:length(missing_fr)){
  #             add_cm = tidyr::extract_numeric(rownames(as.matrix(which(EAD$A_FRCM[missing_fr[s],drop_cm]>0))))
  #             A_PCM[i,add_cm]<-1
  #           }
  #         }else if(length(missing_fr) == 1){
  #           add_cm = tidyr::extract_numeric(rownames(as.matrix(which(EAD$A_FRCM[missing_fr,drop_cm]>0))))
  #           A_PCM[i,add_cm]<-1
  #         }
  #       }
  #     }
  #   }
  #   
  #   rownames(A_PCM) = c(paste0("P", 1:nrow(A_PCM)))
  #   colnames(A_PCM) = c(paste0("CM", 1:ncol(A_PCM)))
  #   EAD$A_PCM = A_PCM
  # }else{
  #   A_PCM = EAD$A_PCM
  # }
  # 
#####
  
  
  #1. compute total production quantities
  pcm_total = EAD$DEMAND * EAD$A_PCM
  cmav_total = colSums(pcm_total) * EAD$A_CMAV
  avrc_total = colSums(cmav_total) * EAD$A_AVRC
  #1.1 total production quantities based on features
  pfr_total = EAD$DEMAND * EAD$A_PFR
  frcm_total = colSums(pfr_total) * EAD$A_FRCM
  


  #2. Compute RCC (total costs)
  RCC = as.vector(c(c(colSums(avrc_total[,(1:EAD$unitsize)])*EAD$RCU[1:EAD$unitsize]),EAD$RCU[(EAD$unitsize+1):EAD$NUMB_RC]))
  EAD$RCC = RCC

  #3.calculate costs for every domain
  c_avrc = sweep(sweep((avrc_total),2,colSums(avrc_total),"/"),MARGIN=2, as.vector(EAD$RCC), `*`)
  c_cmrc = sweep((cmav_total),2,colSums(cmav_total),"/") %*% c_avrc
  c_prc = sweep((pcm_total),2,colSums(pcm_total),"/") %*% c_cmrc
  #3.1 feature costs
  c_frrc = sweep((frcm_total),2,colSums(frcm_total),"/") %*% c_cmrc
  c_pfc = sweep((pfr_total),2,colSums(pfr_total),"/") %*% c_frrc
  

  #4.calculate benchmark product costs
  PCB = rowSums(c_prc)
  pcb = PCB/EAD$DEMAND
  var_pcb = rowSums(c_prc[,1:EAD$unitsize])/EAD$DEMAND
  cmc = rowSums(c_cmrc)/colSums(pcm_total) # unit-level component costs
  EAD$UL_COST_draw = sum(RCC[1:EAD$unitsize])/sum(RCC)

  #5.calculate feature product costs
  #based on relative matrices
  PCF = rowSums(c_pfc)
  pcf = PCF/EAD$DEMAND
  frc = rowSums(c_frrc)/colSums(pfr_total)
  #based on unit-level component costs and binary frcm matrix
  frcs = rowSums(sweep(EAD$A_FRCM,MARGIN=2, as.vector(cmc), `*`))
  pcfs = rowSums(sweep(EAD$A_PFR,MARGIN=2, as.vector(frcs), `*`))
  #based on unit-level component costs and relative frcm matrix
  frcx = rowSums(sweep(sweep((EAD$A_FRCM),2,colSums(EAD$A_FRCM),"/"),MARGIN=2, as.vector(cmc), `*`))
  pcfx = rowSums(sweep(EAD$A_PFR,MARGIN=2, as.vector(frcx), `*`))
  
  #based on unit-level component costs and weighted relative matrix
  y = (colSums(EAD$A_PFR) * EAD$A_FRCM)/EAD$NUMB_P
  frcy = rowSums(sweep(sweep((y),2,colSums(y),"/"),MARGIN=2, as.vector(cmc), `*`))
  pcfy = rowSums(sweep(EAD$A_PFR,MARGIN=2, as.vector(frcy), `*`))

  
  #6. Sticky costs calculation
  
  #fixed costs, once acquired, cannot be omitted (Banker & Hughes - 1994)
  if(sum(RCC[(EAD$unitsize+1):EAD$NUMB_RC]) >= sum(EAD$RCU[(EAD$unitsize+1):EAD$NUMB_RC])){
  #if more capacity then initially planned is required, adjust max capacity
    
    RCC_max <- RCC[(EAD$unitsize+1):EAD$NUMB_RC]
    
  }else{
    #else, if required capacity is lower than what is already acquired, RCC_max is the initally planned capacity (sticky costs)
    #RCC_max <- c(RCC[1:EAD$unitsize],EAD$RCU[(EAD$unitsize+1):EAD$NUMB_RC])
    RCC_max = EAD$RCC_max
  }
  
  #unused capacity costs (what is already acquired - what is needed)
  UCC = sum(RCC_max) - sum(RCC[(EAD$unitsize+1):EAD$NUMB_RC])



  #benchmark costs
  EAD$UCC = UCC
  EAD$RCC_max <- RCC_max
  EAD$pcb <- pcb
  EAD$PCB <- PCB
  EAD$var_pcb <- var_pcb
  
  #function costs
  EAD$pcf <- pcf

  return(EAD)
  
}

