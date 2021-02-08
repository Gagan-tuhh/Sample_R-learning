## DEFINING PRODUCT PORTFOLIO 
# 
define_ProductPortfolio <- function(EAD, NUMB_C, NUMB_CN, NUMB_FR,NUMB_P, DENS_CCN, DENS_CNFR,DENS_PFR, routine="standard") {
  ####---------MARKET GENERATION (EXTERNAL VIEW)-------------####
 
  ##1.1. CUSTOMER DIVERSITY (Customers x Customer Needs)
  ##1.2. MARKET STRUCTURE (Customer Needs x Functional Requirements)
  EAD = .define_MarketandCustomers(EAD, NUMB_C,NUMB_CN,NUMB_FR,DENS_CCN,DENS_CNFR, routine="standard")
  
  ##1.3. PRODUCT PORTFOLIO ATTRIBUTES (Products x Functional Requirements)
  EAD = .define_Products(EAD, NUMB_P, NUMB_FR, DENS_PFR, routine="standard")
  
  
  
  
return(EAD)
  }







  