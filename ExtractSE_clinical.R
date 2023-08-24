ExtractSE_clinical <- function(data = data){
  as.data.frame(SummarizedExperiment::colData(data))
}


