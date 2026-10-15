
#=======================================#
#Script question 3 devoir 1
#Olivier Vermette
#=======================================#

library(ggplot2)
library(ggpubr)
library(tidyr)
library(car)

data_rna_seq <- read.csv("./data/2_Data_RNASeq_Cannabis_Sex.csv")


#LOC115699937
#grep sans restriction de case nous permet de sélectionner toute les occurences
#sans se préocuper des oublies dans les noms
data_REM16 <- data_rna_seq[grep("LOC115699937", data_rna_seq[,1]),]

#LOC115696989
data_FT1 <- data_rna_seq[grep("LOC115696989", data_rna_seq[,1]),]


#on fait une fonction pour classer les male XY des femelles XX

female_male_classifer <- function(data_frame, ID){
  sample_names <- colnames(data_frame)[-1]
  
  data.frame(
    ID = sample_names,
    Exp_score = as.numeric(data_frame[1, -1]),
    Sex = ifelse(grepl("XY", sample_names), "M", "F"),
    Locus_ID = rep(ID,length(sample_names))
  )
}

organised_F1 <- female_male_classifer(data_FT1,"F1")
organised_REM16 <- female_male_classifer(data_REM16, "REM16")

#fusion des dataframe pour ggplot
organised_data_frame <- rbind(organised_F1,organised_REM16)

#verificarion de la distribution pour t-test

hist(organised_F1[which(organised_F1[,3] == "F"),"Exp_score"])
hist(organised_F1[which(organised_REM16[,3] == "M"),"Exp_score"])

#non normal

leveneTest(organised_F1$Exp_score ~ organised_F1$Sex)
leveneTest(organised_REM16$Exp_score ~ organised_F1$Sex)

#variance similaire
#échantillons de 138, theom central limnite donc t test seras utilisé

sex_colors <- c("F" = "pink", "M" = "cyan")
sex_labels <- c("F" = "Femelle (XX)", "M" = "Mâle (XY)")

# 1. Graphique d'expression pour REM16
REM16_exp_graph <- ggplot(data = organised_REM16, aes(x = Sex, y = Exp_score, fill = Sex, color = Sex)) +
  geom_boxplot(width = 0.45, alpha = 0.85, 
               outlier.shape = TRUE, linewidth = 0.6, 
               color = "black", na.rm = TRUE) +
  geom_jitter(aes(fill = Sex), color = "black", 
              width = 0.15, size = 0.4, na.rm = TRUE) +
  stat_compare_means(comparisons = list( c("F", "M") ), method = "t.test", label = "p.signif")+
  scale_fill_manual(values = sex_colors, 
                    labels = sex_labels) +
  scale_color_manual(values = sex_colors, 
                     labels = sex_labels) +
  scale_x_discrete(labels = sex_labels) +
  ylim(c(5,12))+
  labs(
    title = "Expression du gène REM16 en fonction du sexe",
    subtitle = "LOC115699937 - RNA-Seq chez Cannabis sativa (n = 138)",
    x = "Sexe biologique",
    y = "Niveau d'expression (score normalisé)"
  ) +
  theme_bw()+
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    legend.position = "inside", 
    legend.position.inside = c(0.9, 0.9)
  )
  
print(REM16_exp_graph)

# 2. Graphique d'expression pour F1 / FT1
F1_exp_graph <- ggplot(data = organised_F1, aes(x = Sex, y = Exp_score, fill = Sex, color = Sex)) +
  geom_boxplot(width = 0.45, alpha = 0.85, 
               outlier.shape = TRUE, linewidth = 0.6, 
               color = "black", na.rm = TRUE) +
  geom_jitter(aes(fill = Sex), color = "black", 
              width = 0.15, size = 0.4, na.rm = TRUE) +
  stat_compare_means(comparisons = list( c("F", "M") ), method = "t.test", label = "p.signif")+
  scale_fill_manual(values = sex_colors, 
                    labels = sex_labels) +
  scale_color_manual(values = sex_colors, 
                     labels = sex_labels) +
  scale_x_discrete(labels = sex_labels) +
  ylim(c(5,12))+
  labs(
    title = "Expression du gène FT1 / F1 en fonction du sexe",
    subtitle = "LOC115696989 - RNA-Seq chez Cannabis sativa (n = 138)",
    x = "Sexe biologique",
    y = "Niveau d'expression (score normalisé)"
  ) +
  theme_bw()+
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    legend.position = "inside", 
    legend.position.inside = c(0.9, 0.9)
  )

print(F1_exp_graph)

# 3. Graphique combiné : comparaison des moyennes entre toutes les catégories

# Création de la variable Group pour permettre la comparaison de toutes les catégories
organised_data_frame$Group <- factor(
  interaction(organised_data_frame$Locus_ID, organised_data_frame$Sex),
  levels = c("F1.F", "F1.M", "REM16.F", "REM16.M")
)

comparaisons_all <- list(
  c("F1.F", "F1.M"),        
  c("REM16.F", "REM16.M"),   
  c("F1.F", "REM16.F"),       
  c("F1.M", "REM16.M")        
)

exp_graph <- ggplot(data = organised_data_frame, aes(x = Group, y = Exp_score, fill = Sex)) +
  geom_boxplot(width = 0.55, alpha = 0.85, 
               outlier.shape = TRUE, linewidth = 0.6, 
               color = "black", na.rm = TRUE) +
  geom_jitter(color = "black", size = 0.4, width = 0.15, na.rm = TRUE) +
  stat_compare_means(comparisons = comparaisons_all, method = "t.test", label = "p.signif") +
  scale_fill_manual(values = sex_colors, 
                    labels = sex_labels) +
  scale_x_discrete(labels = c("F1.F" = "F1\nFemelle (XX)", "F1.M" = "F1\nMâle (XY)",
                              "REM16.F" = "REM16\nFemelle (XX)", "REM16.M" = "REM16\nMâle (XY)")) +
  ylim(c(5, 14.5)) +
  labs(
    title = "Expression des gènes F1 et REM16 en fonction du sexe",
    subtitle = "RNA-Seq chez Cannabis sativa (n = 138)",
    x = "Catégories (Gène & Sexe)",
    y = "Niveau d'expression (score normalisé)"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    legend.position = "inside", 
    legend.position.inside = c(0.9, 0.9)
  )

print(exp_graph)

#Avec l'observation des deux gènes, fesons un analyse par composante principale 
#afin de détecter quelle gène sont réellement exprimer de facons différente entre les 
#Male et les femelles




