# SummarizedExperiment-Extract
Two scripts can be easily extract matrix and clinical metadata in SummarizedExperiment format, it can be used for extract files downloaded from TCGAbiolinks.
**`SummarizedExperiment` format**

- `assays`
  - *"unstranded"  =* **counts**
  - *"stranded_first"*
  - *"stranded_second"*
  - *"tpm_unstrand"  =**TPM**
  - *"fpkm_unstrand"*  =**FPKM**
  - *"fpkm_uq_unstrand"*

- rowData :`rowData(se)`**gene annotation**
  - *"source"*
  - *"type"* 
  - *"score"*
  - *"phase"*
  - *"gene_id"*   **ENSEMBLEID**
  - *"gene_type"*   **Distinguish lncRNA or mRNA**
  - *"gene_name"*  ***symbol***
  - *"level"*
  - *hgnc_id"*
  - *"havana_gene"*
# ExtractSE_assay
- Function: Automatically convert the SummarizedExperiment format downloaded by TCGAbiolinks into the required matrix, and convert Ensembl ID into symbol ID, and keep the one with the largest mean value as the gene for the repeated probes.  
- Required R package: "tidyverse","SummarizedExperiment"  
- Input: data in the form of SummarizedExperiment.  
- Output: count,fpkm or tpm matrix with gene as row, samples as column.
```r
ExtractSE_assay(data,
                choose_gene_type = "protein_coding",
                choose_assay="tpm_unstrand")
```
parameters:  
- data: Data in SummarizedExperiment format downloaded with TCGAbiolinks.  
- choose_gene_type: You can choose as follows, "protein_coding" for mRNA, "lncRNA" for lncRNA.  
- choose_assay: You can choose the assay section above.  
example：
```r
library(TCGAbiolinks)
query <- GDCquery(project = "TCGA-CHOL",
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "STAR - Counts")
GDCdownload(query, files.per.chunk = 100)
GDCprepare(query,save = T,save.filename = "TCGA-CHOL_mRNA.Rdata"))
load("TCGA-CHOL_mRNA.Rdata")
#extract assay
ExtractSE_assay(data = data,choose_gene_type = "protein_coding",choose_assay="tpm_unstrand")
head(se,1:3)
```
# ExtractSE_clinical
- On the basis of the above, you only need to input the SummarizedExperiment data downloaded by TCGAbiolinks into the data parameter to generate a dataframe named `clinical`.
example：
```r
#extract clinical metadata
ExtractSE_clinical(data)
head(clinical)
```
