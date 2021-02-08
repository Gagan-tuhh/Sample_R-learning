## Set economic circumstances. 

set_EconomicParameters <- function(EAD,NUMB_P,NUMB_RC,TQ,TC,Q_VAR,RCU_VAR,UL_COST,UL_RES,routine="standard") {
  
  #1. Demand
  EAD = .set_Demand(EAD,NUMB_P,TQ,Q_VAR)
  EAD = .set_Demand_EOQ(EOQ_D, EOQ_S, EOQ_H, EOQ_b)
  EAD = .set_Demand_EPQ(EPQ_D, EPQ_P, EPQ_K, EPQ_H)
  
  

  #2. Resource Costs
  EAD = .set_ResourcePrices(EAD,RCU_VAR,TC,NUMB_RC,UL_COST,UL_RES)

return(EAD)
  
  }







  