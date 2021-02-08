## PRODUCTION ENVIRONMENT GENERATION V 1.3

build_ProductionTechnology <- function(EAD,NUMB_CM,NUMB_AV,NUMB_RC, DENS_CMAV, DENS_AVRC, routine = "2B") {
  
  
  
  ####---------3. FIRM GENERATION (INTERNAL VIEW)--------####
  
  EAD$A_CMAV = .create_designmatrix(NUMB_CM,NUMB_AV,DENS_CMAV,"CM","AV")

 
  #EAD$A_CMAV = .create_designmatrix(NUMB_AV,NUMB_RC,DENS_AVRC,"AV","RC")
 # A_CMAV = EAD$A_CMAV
 # AV = as.vector(CM) %*% (A_CMAV) # computing AV * q
 # EAD$AV = AV
  
  #2.2. RESOURCE STRUCTURE (Processes x Resources)
  if(DENS_AVRC == 0){
    EAD$A_AVRC = .create_designmatrix(NUMB_AV,NUMB_RC,DENS_AVRC,"AV","RC")
  }else{
    EAD = .build_RES_CONS_PAT(EAD,NUMB_AV,NUMB_RC,DENS_AVRC)
  }
   #Processed - Resources Matrix
 # EAD$A_AVRC = A_AVRC
 #RC = as.vector(AV) %*% (A_AVRC) # computing RC * q
 # EAD$RC = RC


  
  
return(EAD)}



