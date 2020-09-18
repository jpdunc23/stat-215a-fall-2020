library(tidyverse)

loadBRCAData <- function(filepath="./data/tcga_brca.Rdata") {
  # function to load in TCGA BRCA data with clinical data (including subtypes)
  #
  # returns: list of 2
  #  -X = n x p data matrix of mRNA expression values
  #  -Y = n x K data matrix of clinical responses
  
  if (!file.exists(filepath)) {
    require(TCGA2STAT)
    require(TCGAbiolinks)
    brca_orig <- getTCGA(disease = "BRCA", 
                         data.type = "mRNA_Array", clinical = T)
    
    # get gene expression data merged with clinical data
    X_orig <- brca_orig$merged.dat %>%
      rename(patient = bcr) %>%
      select(-OS, -status) %>%
      na.omit()
    
    # get BRCA subtypes
    brca_subt <- TCGAquery_subtype(tumor = "BRCA") %>%
      select(patient, BRCA_Subtype_PAM50, vital_status) %>%
      filter(BRCA_Subtype_PAM50 != "Normal")
    
    # merge data with subtypes
    dat <- inner_join(x = X_orig, y = brca_subt, by = "patient")
    
    # split data into covariates and responses
    X <- dat %>%
      select(-vital_status, -BRCA_Subtype_PAM50) %>%
      column_to_rownames("patient")
    Y <- dat %>%
      select(patient, BRCA_Subtype_PAM50, vital_status) %>%
      column_to_rownames("patient") %>%
      mutate_if(is.character, as.factor)
    save(X = X, Y = Y, file = filepath)
  } else {
    load(filepath)
  }
  
  return(list(X = X, Y = Y))
}
