
#=======================================#
#Script question 3 devoir 1
#Olivier Vermette
#=======================================#

library(ggplot2)
library()

data_rna_seq <- read.csv("./data/2_Data_RNASeq_Cannabis_Sex.csv")


#LOC115699937
data_REM16 <- data_rna_seq[which(data_rna_seq[,1] == "LOC115696989"),]

#LOC115696989
data_FT1 <- data_rna_seq[which(data_rna_seq[,1] == "LOC115696989"),]

data_sex_REM16 <- data.frame(Male = c(0),
                             Female = c(0))










