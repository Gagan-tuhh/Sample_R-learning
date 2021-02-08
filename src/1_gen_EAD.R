# # MAIN FUNCTION FOR GENERATING A PRODUCT PROGRAM
gen_EAD <- function(EAD,TQ,TC) {

#  % 23.4. - Generates the customers in the market Customer generation function
#  % 24.7. - Make customers' attributes more precise, in particular CN and FRN
#  % 01.10 - Code simplification 
#  % 04.2  - Cost calculation implemented
#  % 05.02 - Simulation has been implemented 
#  % 25.02 - Update Product architecture generation
#  % 19.03 - Update Demand function
#  % 19.03 - Update Customer diversity 
#  % 19.03 - Market structure
#  % 01.09 - Restructuring EAD Routine; 
  

#####-------------CASE-------------#####
if(EAD$case != 0) {
EAD = .EAD_example(EAD)
NUMB_C = EAD$NUMB_C #Customers
NUMB_CN = EAD$NUMB_CN #Customer' needs 
NUMB_FR = EAD$NUMB_FR #Functional Requirements
NUMB_CM = EAD$NUMB_CM #Components
NUMB_AV = EAD$NUMB_AV #Processes
NUMB_RC = EAD$NUMB_RC #Resources
NUMB_P = EAD$NUMB_P
Q_VAR = EAD$Q_VAR
RCU_VAR = EAD$RCU_VAR
unitsize = EAD$unitsize   #number of unit-level resources
DENS_CCN =  EAD$DENS_CCN
DENS_CNFR = EAD$DENS_CNFR
DENS_FRCM = EAD$DENS_FRCM
DENS_CMAV = EAD$DENS_CMAV
DENS_AVRC = EAD$DENS_AVRC
DENS_PFR = EAD$DENS_PFR
DENS_PCM = EAD$DENS_PCM
A_CCN = EAD$A_CCN
A_CNFR = EAD$A_CNFR
A_FRCM = EAD$A_FRCM
A_CMAV = EAD$A_CMAV
A_AVRC = EAD$A_AVRC
A_PFR = EAD$A_PFR
A_PCM = EAD$A_PCM

# DEMAND = EAD$DEMAND
RCU = EAD$RCU

} # CASE STUDY


####-------------- SIMULATION ------------------ ####  
else{
 
  ### Simulation Routine #### 
  NUMB_C = EAD$NUMB_C #Customers
  NUMB_P = EAD$NUMB_P #Products
  NUMB_CN = EAD$NUMB_CN #Customer' needs 
  NUMB_FR = EAD$NUMB_FR #Functional Requirements
  NUMB_CM = EAD$NUMB_CM #Components
  NUMB_AV = EAD$NUMB_AV #Processes
  NUMB_RC = EAD$NUMB_RC #Resources
  Q_VAR = EAD$Q_VAR
  RCU_VAR = EAD$RCU_VAR
  DENS_CCN =  EAD$DENS_CCN
  DENS_PFR = EAD$DENS_PFR
  DENS_PCM = EAD$DENS_PCM
  DENS_CNFR = EAD$DENS_CNFR
  DENS_FRCM = EAD$DENS_FRCM
  DENS_CMAV = EAD$DENS_CMAV
  DENS_AVRC = EAD$DENS_AVRC
  UL_COST = EAD$UL_COST
  UL_RES = EAD$UL_RES


  EAD = set_EconomicParameters(EAD,NUMB_P,NUMB_RC,TQ,TC,Q_VAR,RCU_VAR,UL_COST,UL_RES, routine="standard")

  EAD = define_ProductPortfolio(EAD, NUMB_C,NUMB_CN, NUMB_FR,NUMB_P, DENS_CCN, DENS_CNFR,DENS_PFR, routine="standard")
  
  
  EAD = design_ProductFamilies(EAD,NUMB_FR,NUMB_P, NUMB_CM, DENS_FRCM,DENS_PCM, routine="standard")
   
  EAD = build_ProductionTechnology(EAD,NUMB_CM,NUMB_AV,NUMB_RC, DENS_CMAV, DENS_AVRC, routine = "standard")

    

}
  
return(EAD)
}





  