##
design_ProductFamilies <- function(EAD,NUMB_FR,NUMB_P, NUMB_CM, DENS_FRCM,DENS_PCM, routine="standard") {
  
  ####---------2. PRODUCT ARCHITECTURE GENERATION (MAPPING)----------####
  
  # (Functional Requirements x Components)
  A_FRCM = .create_designmatrix(NUMB_FR,NUMB_CM,DENS_FRCM,"FR","CM") #Functional Requirements - Components Matrix
  EAD$A_FRCM = A_FRCM
  
  A_PCM = .create_designmatrix(NUMB_P,NUMB_CM,DENS_PCM,"P","CM") #Functional Requirements - Components Matrix
  EAD$A_PCM = A_PCM
  
# repeat{
#   
#   #Match PCM, PFR and FRCM
#   DUPL_ROWS_PCM <- any(duplicated(EAD$A_PCM)==TRUE)
#   DUPL_ROWS_PFR <- any(duplicated(EAD$A_PFR)==TRUE)
#   
#   if(DUPL_ROWS_PFR == FALSE | DUPL_ROWS_PCM == FALSE){#if there are now duplicate rows in PFR and PCM, match FRCM and PCM and PFR
  
  
  
# 
#      for (i in 1:EAD$NUMB_P) {
#       repeat {
#         FR_to_keep = which(EAD$A_PFR[i, ] > 0, arr.ind = TRUE) #Rows
#         CM_to_keep = which(EAD$A_PCM[i, ] > 0, arr.ind = TRUE) #Cols
#         A_P_i = matrix(EAD$A_FRCM[FR_to_keep, CM_to_keep],nrow = length(FR_to_keep),ncol = length(CM_to_keep))
#         r = rowSums(A_P_i)
#         c = colSums(A_P_i)
#         
#         if (0 %in% r) {
#           zeros_in_r = which(r == 0, arr.ind = TRUE)
#           rows_to_inspect = FR_to_keep[zeros_in_r] # Zeilen in A_FRCM in denen wir nach 1 suchen
#           ones_in_row = which(EAD$A_FRCM[rows_to_inspect[1], ] > 0, arr.ind = TRUE) #Indizes der Einsen in Zeile "rows_to_inspect[1]"
#           EAD$A_PCM[i, ones_in_row[1]] = 1
#         } else if (0 %in% c) {
#           zeros_in_c = which(c == 0, arr.ind = TRUE)
#           cols_to_inspect = CM_to_keep[zeros_in_c] # Spalten in A_FRCM in denen wir nach 1 suchen
#           #ones_in_col = which(EAD$A_FRCM[, cols_to_inspect[1]] > 0, arr.ind = TRUE) #Indizes der Einsen in Zeile "rows_to_inspect[1]"
#           EAD$A_PFR[i, cols_to_inspect] = 0
#         } else {
#           break
#         }
#       }
#     } 
#     
#   
  
  
  
  
#     break 
#     
#   }else{
#     A_FRCM = .create_designmatrix(NUMB_FR,NUMB_CM,DENS_FRCM,"FR","CM") #Functional Requirements - Components Matrix
#     EAD$A_FRCM = A_FRCM
#   }
# }
  
  
  #Number of functional requirements must be equal to the number of components. (symmetrical matrix needed)
  #  if(EAD$TYPE_FRCM != "C"){
  #  if(sum(diag(A_FRCM))<NUMB_FR)  {
  #   diag(A_FRCM) <- 1
  #   A_FRCM[!lower.tri(A_FRCM,diag=TRUE)] <- 0
  # }
  #  }
 # EAD$DENS_FRCM_measured = count_nonzeros(A_FRCM) #set DENS_FRCM is not strictly the implemented.
  
  
  
return(EAD)}






  