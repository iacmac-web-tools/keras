# api.R
setwd("/home/plumber")
library(keras)
library(rjson)
modelXXX <- load_model_hdf5("my4model")


# set API title and description to show up in http://localhost:8000/__swagger__/

#' @apiTitle Run predictions for MIC testing
#' @apiDescription This API takes RGB matrixs of 96 images and predict MIC


#* @filter logger
function(req){
  cat(as.character(Sys.time()), "-", 
      req$REQUEST_METHOD, req$PATH_INFO, "-", 
      req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR,"\n" )
  plumber::forward()
}



#* @post /ai
snp <- function(req){
 # res$setHeader("Access-Control-Allow-Origin", "*")
  object<-req$postBody
  object <- fromJSON(object)
  if (!is.null(object)){
  
    object <- array(object, dim=c(96,50,50,3))
    
    
    d <- dim(object)
    if(length(d) == 4){
      if(d[1] == 96 & d[2] == 50 & d[3] == 50 & d[4] == 3){
        object <- modelXXX %>% predict_classes(object)
        return(object)
      }else{
        return("Incorrect dimension")
      }
    }else{
      return("Incorrect dimension")
    }
  }
  
  
  
  
  
}


#* @get /test
summm<- function(){
  x <- rnorm(10)
  return(x)
}
