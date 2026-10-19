#==============================================================================#
# PROJET      : BVG-7003 — Devoir 1 (Question 3)
# LANGAGE     : R (version >= 4.0)
# AUTEUR      : Olivier Vermette
# SESSION     : Automne 2026
# DESCRIPTION : Traitement RNA-Seq, tests statistiques et visualisations (REM16 & FT1)
# PACKAGES    : ggplot2, ggpubr, tidyr, car, scales, grid
# ENCODAGE    : UTF-8
#==============================================================================#


library(ggplot2)  
library(ggpubr)   
library(tidyr)   
library(car)      
library(scales)   
library(grid)     

data_rna_seq <- read.csv("./data/2_Data_RNASeq_Cannabis_Sex.csv")


#LOC115699937
#on fait un grep sans restriction car certain ID ont des compositions 
#différente, dont REM16
data_REM16 <- data_rna_seq[grep("LOC115699937", data_rna_seq[,1]),]

#LOC115696989
data_FT1 <- data_rna_seq[grep("LOC115696989", data_rna_seq[,1]),]


#on fait une fonction pour classer les male XY des femelles XX grace à leurs ID

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
hist(organised_REM16[which(organised_REM16[,3] == "M"),"Exp_score"])

#non normal mais t-test rigoureux avec variance équivalente

leveneTest(organised_F1$Exp_score ~ organised_F1$Sex)
leveneTest(organised_REM16$Exp_score ~ organised_REM16$Sex)

#variance similaire donc le t-test est acceptable ici
#et notre nombre d'individue est acceptable, 138 
#Sur ce, je fait un t-test

sex_colors <- c("F" = "darkmagenta", "M" = "darkgreen")
sex_labels <- c("F" = "Femelle (XX)", "M" = "Mâle (XY)")

#Graphique d'expression pour REM16
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

#Graphique d'expression pour F1 / FT1
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

#Graphique combiné : comparaison des moyennes entre toutes les catégories
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


#=================================#
#Avec l'observation des deux gènes donner, on voit que REM16 est surexprimer chez les femelles
#Toutefois fesons un analyse par composante principale 
#afin de détecter si ce gène est réellement le meilleur pour discriminer les
#Males et les femelles

transpose_data_rna_seq <- t(data_rna_seq[, -1])
colnames(transpose_data_rna_seq) <- data_rna_seq[, 1]

# Gestion de la valeur manquante (NA) sur le gène LOC115696989 (FT1) pour l'échantillon 011_XX
#détecter par l'agent lors d'une analyse des données
transpose_data_rna_seq[is.na(transpose_data_rna_seq)] <- mean(transpose_data_rna_seq[, "LOC115696989"], na.rm = TRUE)

# Analyse en Composantes Principales
pca_result <- prcomp(transpose_data_rna_seq, scale. = TRUE)
summary(pca_result)
scores <- pca_result$x
loadings <- pca_result$rotation

# Visualisation des individus sur PC1 et PC2
var_exp <- summary(pca_result)$importance[2, 1:2] * 100 #afin d'avoir un pourcentage

pca_df <- data.frame(
  Sample = rownames(transpose_data_rna_seq),
  PC1 = scores[, 1],
  PC2 = scores[, 2],
  Sex = ifelse(grepl("XY", rownames(transpose_data_rna_seq)), "M", "F")
)

pca_graph <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Sex, fill = Sex)) +
  stat_ellipse(geom = "path", linewidth = 0.8, linetype = "dashed", level = 0.95, show.legend = FALSE, type = "norm") + 
  #J'ai décider de prendre le clustering selon une distribution normal, étais plus inclusif 
  geom_point(size = 3, alpha = 0.85, shape = 21, color = "black") +
  scale_fill_manual(values = sex_colors, labels = sex_labels) +
  scale_color_manual(values = sex_colors, labels = sex_labels) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", alpha = 0.5) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", alpha = 0.5) +
  labs(
    title = "Analyse en Composantes Principales (ACP) du transcriptome",
    subtitle = "Projection des 138 échantillons RNA-Seq chez Cannabis sativa selon le sexe",
    x = paste0("PC1 (", round(var_exp[1], 2), "% de variance expliquée)"),
    y = paste0("PC2 (", round(var_exp[2], 2), "% de variance expliquée)")
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    legend.position = "bottom",
    legend.position.inside = c(0.88, 0.88)
  )

print(pca_graph)

scores <- pca_result$x
sexe <- ifelse(grepl("XY", rownames(transpose_data_rna_seq)), "M", "F")


#test des différence statistique entre PC1 et PC2 pour le sex
#t-test car je veux simplement comparer les moyenne a priori
t.test(scores[, 1] ~ sexe) 
t.test(scores[, 2] ~ sexe)

# PC2 différencie significativement les sexes (p < 1e-20), tandis que PC1
# capture un facteur majeur non lié au sexe (stade de développement, tissu ou lot d'échantillonnage).
# Pour isoler les gènes réellement discriminants du sexe sans le bruit de PC1,
# nous sélectionnons les gènes selon leurs loadings sur PC2, donc, leurs points sur la variance.

loadings_pc2 <- pca_result$rotation[, "PC2"]
top25_F <- names(head(sort(loadings_pc2, decreasing = TRUE), 25))
top25_M <- names(head(sort(loadings_pc2, decreasing = FALSE), 25))
top50_genes <- c(top25_F, top25_M)

#Barplot : Top 10 Mâles et Top 10 Femelles (+ position de REM16 à #11)
top10_F <- head(sort(loadings_pc2, decreasing = TRUE), 10)
top10_M <- head(sort(loadings_pc2, decreasing = FALSE), 10)
rem16_loading <- loadings_pc2["Cannabis_LOC115699937"]

df_barplot <- data.frame(
  Gene = c(names(top10_F), "Cannabis_LOC115699937", names(top10_M)),
  Loading = c(top10_F, rem16_loading, top10_M),
  Sex = factor(c(rep("F", 11), rep("M", 10)), levels = c("F", "M"))
)

df_barplot$Gene_clean <- gsub("Cannabis_", "", df_barplot$Gene)
df_barplot$Gene_clean[df_barplot$Gene_clean == "LOC115699937"] <- "LOC115699937 (REM16 #11)"
df_barplot$Gene_clean <- factor(df_barplot$Gene_clean, levels = df_barplot$Gene_clean[order(df_barplot$Loading)])

barplot_top10 <- ggplot(df_barplot, aes(x = Loading, y = Gene_clean, fill = Sex)) +
  geom_col(width = 0.72, color = "black", linewidth = 0.3) +
  geom_vline(xintercept = 0, linetype = "solid", color = "black") +
  scale_fill_manual(values = sex_colors, labels = sex_labels) +
  labs(
    title = "Top gènes marqueurs (PC2)",
    subtitle = "Top 10 Mâles / Femelles + position de REM16 (#11)",
    x = "PC2 (Contribution à la séparation)",
    y = "Gènes",
    fill = "Sexe :"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 9.5, hjust = 0.5),
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 8.5),
    legend.position = "bottom"
  )

#Heatmap des 50 gènes les plus discriminants entre femelle et mâle
mat_top50 <- transpose_data_rna_seq[, top50_genes]
# Standardisation en Z-score par gène afin de discriminer les plus exprimer par rapport à la moyenne et la variance
mat_top50_scaled <- scale(mat_top50)

df_heatmap <- as.data.frame(mat_top50_scaled)
df_heatmap$Sample <- rownames(df_heatmap)
df_heatmap$Sex <- factor(ifelse(grepl("XY", df_heatmap$Sample), "M", "F"), levels = c("F", "M"))

df_heatmap_long <- pivot_longer(df_heatmap, cols = all_of(top50_genes), names_to = "Gene", values_to = "Z_Score")
df_heatmap_long$Gene_clean <- gsub("Cannabis_", "", df_heatmap_long$Gene)
df_heatmap_long$Gene_clean[df_heatmap_long$Gene_clean == "LOC115699937"] <- "LOC115699937 (REM16)"

gene_order <- gsub("Cannabis_", "", top50_genes)
gene_order[gene_order == "LOC115699937"] <- "LOC115699937 (REM16)"
df_heatmap_long$Gene_clean <- factor(df_heatmap_long$Gene_clean, levels = rev(gene_order))

# Ordonner les échantillons par sexe
df_heatmap_long$Sample <- factor(
  df_heatmap_long$Sample,
  levels = rownames(transpose_data_rna_seq)[order(grepl("XY", rownames(transpose_data_rna_seq)))]
)

heatmap_top50 <- ggplot(df_heatmap_long, aes(x = Sample, y = Gene_clean, fill = Z_Score)) +
  geom_tile() +
  facet_grid(~ Sex, scales = "free_x", space = "free", labeller = as_labeller(sex_labels)) +
  scale_fill_viridis_c(
    option = "inferno",
    limits = c(-3, 3), oob = scales::squish, name = "Z-score"
  ) +
  labs(
    title = "Heatmap des 50 gènes les plus discriminants (PC2)",
    subtitle = "Top 25 Femelles (haut) | Top 25 Mâles (bas)",
    x = "Individues (n = 138)",
    y = "Gènes"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 9.5, hjust = 0.5),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 6),
    strip.background = element_rect(fill = "white"),
    strip.text = element_text(face = "bold", size = 9.5),
    legend.position = "bottom",
    legend.key.width = unit(1.2, "cm"),
    legend.key.height = unit(0.35, "cm")
  )

# Combinaison côte à côte des deux graphiques
combined_sex_markers_plot <- ggarrange(heatmap_top50, barplot_top10, ncol = 2, widths = c(1.35, 1))
print(combined_sex_markers_plot)

# Print d'un tableau récapitulatif des gènes du bar plot
genes_barplot <- c(names(top10_F), "Cannabis_LOC115699937", names(top10_M))
sexe_echantillons <- ifelse(grepl("XY", rownames(transpose_data_rna_seq)), "M", "F")

mean_F <- colMeans(transpose_data_rna_seq[sexe_echantillons == "F", genes_barplot])
mean_M <- colMeans(transpose_data_rna_seq[sexe_echantillons == "M", genes_barplot])

tableau_top_genes <- data.frame(
  Rang = c(paste0("F", 1:10), "F11 (REM16)", paste0("M", 1:10)),
  Sexe_Associe = c(rep("Femelle (XX)", 11), rep("Mâle (XY)", 10)),
  Gene_ID = gsub("Cannabis_", "", genes_barplot),
  Loading_PC2 = round(c(top10_F, rem16_loading, top10_M), 5),
  Moyenne_F = round(mean_F, 2),
  Moyenne_M = round(mean_M, 2),
  Diff_F_M = round(mean_F - mean_M, 2),
  stringsAsFactors = FALSE
)

rownames(tableau_top_genes) <- NULL

cat("\n=======================================================\n")
cat("Tableau des gènes les plus discriminants (Bar plot - PC2)\n")
cat("=======================================================\n")
print(tableau_top_genes)

# On fait un volcano plot afin de détecter les gènes qui s'expriment de façon significative chez les femelles 
# par rapport aux mâles et si REM16 y reste car il semble être le gène avec la différence d'expression la plus importante

# Calcul des tests t de Welch pour les 20 500 gènes
p_valeurs <- apply(transpose_data_rna_seq, 2, function(gene) {
  t.test(gene ~ sexe_echantillons)$p.value
})

# Calcul de la différence d'expression moyenne (Femelles - Mâles)
m_F <- colMeans(transpose_data_rna_seq[sexe_echantillons == "F", ])
m_M <- colMeans(transpose_data_rna_seq[sexe_echantillons == "M", ])
diff_expression <- m_F - m_M

# Ajustement des p-valeurs par la méthode de Benjamini-Hochberg (FDR)
p_ajustees <- p.adjust(p_valeurs, method = "BH")

df_volcano <- data.frame(
  Gene = colnames(transpose_data_rna_seq),
  Diff = diff_expression,
  P_val = p_valeurs,
  P_adj = p_ajustees,
  Neg_Log10_Padj = -log10(p_ajustees),
  stringsAsFactors = FALSE
)

# Catégorisation selon les seuils biologiques (|Diff| > 1) et statistiques (p.adj < 0.05)
df_volcano$Status <- "Non significatif"
df_volcano$Status[df_volcano$P_adj < 0.05 & df_volcano$Diff > 1] <- "Sur-exprimé chez Femelles"
df_volcano$Status[df_volcano$P_adj < 0.05 & df_volcano$Diff < -1] <- "Sur-exprimé chez Mâles"
df_volcano$Status <- factor(df_volcano$Status, levels = c("Non significatif", "Sur-exprimé chez Femelles", "Sur-exprimé chez Mâles"))

# Ciblage des gènes les plus significatifs 
genes_femelles <- df_volcano[df_volcano$Status == "Sur-exprimé chez Femelles", ]
genes_males    <- df_volcano[df_volcano$Status == "Sur-exprimé chez Mâles", ]

top_femelle <- genes_femelles[which.max(genes_femelles$Neg_Log10_Padj), ]
top_male    <- genes_males[which.max(genes_males$Neg_Log10_Padj), ]

df_targets <- rbind(top_femelle, top_male)
df_targets$Label <- ifelse(
  grepl("115699937", df_targets$Gene),
  paste0("REM16 (", gsub("Cannabis_", "", df_targets$Gene), ")\nTop Femelle (p.adj = ", formatC(df_targets$P_adj, format = "e", digits = 1), ")"),
  paste0(df_targets$Gene, "\nTop Mâle (p.adj = ", formatC(df_targets$P_adj, format = "e", digits = 1), ")")
)

volcano_colors <- c(
  "Non significatif" = "grey75",
  "Sur-exprimé chez Femelles" = "darkmagenta",
  "Sur-exprimé chez Mâles" = "darkgreen"
)

volcano_plot <- ggplot(df_volcano, aes(x = Diff, y = Neg_Log10_Padj)) +
  geom_point(aes(color = Status), alpha = 0.45, size = 1.2) +
  scale_color_manual(values = volcano_colors) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black", linewidth = 0.5) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "black", linewidth = 0.5) +
  geom_point(data = df_targets[grepl("115699937", df_targets$Gene), ], aes(x = Diff, y = Neg_Log10_Padj), 
             color = "black", fill = "magenta", shape = 21, size = 3.5, stroke = 1.2) +
  geom_point(data = df_targets[grepl("133032448", df_targets$Gene), ], aes(x = Diff, y = Neg_Log10_Padj), 
             color = "black", fill = "green2", shape = 21, size = 3.5, stroke = 1.2) +
  geom_label(
    data = df_targets[grepl("115699937", df_targets$Gene), ],
    aes(x = Diff, y = Neg_Log10_Padj, label = Label),
    nudge_x = -0.3, nudge_y = -3, hjust = 1,
    size = 3.3, fontface = "bold", fill = "white", alpha = 0.9
  ) +
  geom_label(
    data = df_targets[grepl("133032448", df_targets$Gene), ],
    aes(x = Diff, y = Neg_Log10_Padj, label = Label),
    nudge_y = 6, hjust = 0.5,
    size = 3.3, fontface = "bold", fill = "white", alpha = 0.9
  ) +
  labs(
    title = "Volcano Plot de l'expression (Femelles vs Mâles)",
    subtitle = "20 500 gènes RNA-Seq chez Cannabis sativa (Seuils : |Diff| > 1 et p.adj < 0.05)",
    x = "Différence d'expression moyenne (Femelles - Mâles)",
    y = "-log10(p-valeur ajustée FDR)",
    color = "Statut :"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 13, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5),
    legend.position = "bottom"
  )

print(volcano_plot)

# Sauvegarde des graphiques en grand format (haute résolution 300 DPI)
if (!dir.exists("figure")) dir.create("figure", showWarnings = FALSE)

#ggsave("figure/REM16_exp_graph.png", plot = REM16_exp_graph, width = 8, height = 6.5, dpi = 300)
#ggsave("figure/F1_exp_graph.png", plot = F1_exp_graph, width = 8, height = 6.5, dpi = 300)
#ggsave("figure/exp_graph.png", plot = exp_graph, width = 10, height = 6.5, dpi = 300)
#ggsave("figure/pca_graph.png", plot = pca_graph, width = 9, height = 7, dpi = 300)
#ggsave("figure/combined_sex_markers_plot.png", plot = combined_sex_markers_plot, width = 14, height = 8.5, dpi = 300)
#ggsave("figure/volcano_plot.png", plot = volcano_plot, width = 10, height = 7.5, dpi = 300)

# Malgré que REM16 pèse moins dans la PCA, il est le plus exprimé chez les femelles par rapport aux mâles, 
# faisant de lui un gène candidat pour la détermination du sexe par transcriptomique





