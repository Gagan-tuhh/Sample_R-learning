###SCRIPT FOR BASIC ANALYSIS OF THE OUTPUT###


.analyze_output <- function(DATA, x, y, z){
  
  
 
  
  #print(x)
  #colnames(DATA)
  
  #x<-eval(substitute(x),DATA, parent.frame())
  #y<-eval(substitute(y),DATA, parent.frame())
  #z<-eval(substitute(z),DATA, parent.frame())
  #data_agg = aggregate(.~DATA[[x]], DATA, FUN = mean)
  
  #x<- substitute(x)
  
  
  # x = substitute(x)
  # y = substitute(y)
  # z = substitute(z)
  # 
  
  #data_agg = aggregate(.~x, DATA, FUN = mean)
  
  # eval(substitute(y), DATA)
  # eval(substitute(z), DATA)
  # 
  if(is.null(y) & is.null(z)){
    data_agg = aggregate(.~DATA[[x]], DATA, FUN = mean)
  }else if (!is.null(y) & is.null(z)){
    data_agg = aggregate(.~DATA[[x]]+DATA[[y]], DATA, FUN = mean)
  }else if (!is.null(y)& !is.null(z)){
    data_agg = aggregate(.~DATA[[x]]+DATA[[y]]+DATA[[z]], DATA, FUN = mean)
  }
  
  return(data_agg)
}


