#extract SummarizedExperiment
#自动将ENSEMBL ID转化为symbol，并且根据重复探针的均值去重
#需要的R包： c("tidyverse","SummarizedExperiment")
#输入：SummarizedExperiment形式的data
#输出：行为symbol，列为样本的矩阵
#参数解释：data：数据输入，choose_gene_type：选择基因的类型，转录组填protein_coding。choose_assay：表达矩阵类型 
ExtractSE_assay <- function(data,choose_gene_type = "protein_coding",choose_assay="tpm_unstrand"){
  library(tidyverse)
  # 提取rowData
  rowdata <- SummarizedExperiment::rowData(data)
  mrna <- data[rowdata$gene_type == choose_gene_type,]#提取mrna
  se <- SummarizedExperiment::assay(mrna,choose_assay) #提取assay数据
  # 先提取gene_name
  symbol_mrna <- SummarizedExperiment::rowData(mrna)$gene_name
  expr_counts_mrna_symbol <- cbind(data.frame(symbol_mrna),
                                   as.data.frame(se))
  #根据平均值去重
  se <<- expr_counts_mrna_symbol %>% 
    as_tibble() %>% #将data.frame转换为tibble
    mutate(meanrow = rowMeans(.[,-1]), .before=2) %>% #mutate添加新列，表示计算除了第一列以外的平均值，.before把结果放在第二列前面
    arrange(desc(meanrow)) %>% #按降序排序
    distinct(symbol_mrna,.keep_all=T) %>% #根据symbol_mrna列去除重复行，并保留所有其他列的内容
    select(-meanrow) %>% #选择除meanrow列以外的列（也就是删除第二列meanrow）
    column_to_rownames(var = "symbol_mrna") %>% #将symbol_mrna列作为行名
    as.data.frame()#将tibble转化回data.frame
   names <- substring(colnames(se),1,16)
}