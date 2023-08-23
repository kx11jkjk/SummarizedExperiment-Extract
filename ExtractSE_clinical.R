ExtractSE_clinical <- function(data = data){
  clinical <- SummarizedExperiment::colData(data)
  clinical <<- as.data.frame(clinical)
}


