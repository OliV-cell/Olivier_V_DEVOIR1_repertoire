# Fonctionnement du pipeline (Question 3)

Ce document décrit les différentes étapes implémentées dans le script [`code/code_question_3.r`](../code/code_question_3.r) pour l'analyse des données transcriptomiques de *Cannabis sativa*.

---

## Schéma du pipeline

```text
========================================================================================
                     PIPELINE D'ANALYSE TRANSCRIPTOMIQUE (RNA-Seq)
========================================================================================

  [ Données RNA-Seq brutes ]
    └── data/2_Data_RNASeq_Cannabis_Sex.csv (138 échantillons × ~20 500 gènes)
          │
          ▼
  [ 1. Prétraitement & Classification ]
    ├── Annotation du sexe biologique : XX (Femelles) vs XY (Mâles)
    ├── Imputation de la valeur NA sur FT1 (échantillon 011_XX)
    └── Extraction ciblée des gènes candidats : REM16 & FT1/F1
          │
          ├───────────────────────────────┬───────────────────────────────┐
          ▼                               ▼                               ▼
  [ 2. Analyse Univariée ]        [ 3. Analyse Multivariée ]      [ 4. Criblage Global ]
    ├── Postulats statistiques      ├── Standardisation globale     ├── Tests t (20 500 gènes)
    │   (Normalité & Levene)        ├── ACP (prcomp, scale=TRUE)    ├── Correction FDR (B-H)
    ├── Tests t bilatéraux          ├── PC1 : Effet tiers           ├── Filtres : |Diff| > 1
    └── Boxplots & Significativité  ├── PC2 : Sexe                  │             Padj < 0.05
          │                         └── Loadings (Top 50 gènes)     └── Focus REM16 / Mâle
          │                               │                               │
          ▼                               ▼                               ▼
  [ Figures Univariées ]          [ Figures Multivariées ]        [ Figure Volcano ]
    ├── REM16_exp_graph.png         ├── pca_graph.png               └── volcano_plot.png
    ├── F1_exp_graph.png            └── combined_sex_markers_plot
    └── exp_graph.png
========================================================================================
```

---

## Étapes détaillées

### 1. Prétraitement et classification des échantillons
- **Données sources :** Tableau d'expression de 138 individus (mâles et femelles).
- **Classification automatique :** Fonction `female_male_classifer` identifiant le sexe à partir des identifiants des colonnes (`XX` $\rightarrow$ Femelle `F`, `XY` $\rightarrow$ Mâle `M`).
- **Gestion des valeurs manquantes :** Imputation par la moyenne de la valeur manquante (`NA`) observée sur l'échantillon `011_XX` pour le gène *FT1* (`LOC115696989`).

---

### 2. Analyse des gènes candidats (*REM16* et *FT1/F1*)
- **Gènes évalués :**
  - **REM16** (`LOC115699937`) : Marqueur méristématique floral.
  - **FT1 / F1** (`LOC115696989`) : Homologue de floraison (*Flowering Locus T*).
- **Validation statistique des postulats :**
  - Évaluation de la distribution empirique.
  - Test d'homogénéité des variances de Levene (`car::leveneTest`) confirmant l'égalité des variances ($p > 0.05$).
- **Comparaisons de moyennes :** Tests $t$ de Student avec affichage des niveaux de significativité (`stat_compare_means`).
- **Sorties générées :**
  - [`figure/REM16_exp_graph.png`](../figure/REM16_exp_graph.png) : Boxplot montrant une nette surexpression chez les femelles.
  - [`figure/F1_exp_graph.png`](../figure/F1_exp_graph.png) : Boxplot montrant des niveaux comparables entre sexes.
  - [`figure/exp_graph.png`](../figure/exp_graph.png) : Vue combinée à 4 catégories.

---

### 3. Analyse exploratoire (ACP / PCA)
- **Objectif :** Déterminer la structure globale du jeu de données et vérifier si le sexe biologique constitue la source principale de variance.
- **Résultats de l'ACP (`prcomp`) :**
  - **PC1 :** Capture la plus grande part de variance mais n'est pas corrélée au sexe ($p > 0.05$ au test $t$). Elle reflète un effet biologique tiers (ex. type de tissu méristématique vs végétatif ou stade de maturité).
  - **PC2 :** Sépare significativement les sexes ($p < 10^{-20}$ au test $t$).
- **Sortie générée :**
  - [`figure/pca_graph.png`](../figure/pca_graph.png) : Plan factoriel PC1 vs PC2 avec ellipses normales de confiance à 95 %.

---

### 4. Sélection des biomarqueurs les plus discriminants (Loadings PC2)
- **Critère de sélection :** Tri des gènes selon leurs contributions (loadings) le long de **PC2**.
  - **Pôle Femelle (loadings positifs) :** Top 25 des gènes surexprimés chez les femelles (où *REM16* se classe au 11ᵉ rang global).
  - **Pôle Mâle (loadings négatifs) :** Top 25 des gènes surexprimés chez les mâles.
- **Visualisations combinées :**
  - **Heatmap Z-score standardisée :** Vue d'ensemble des 50 biomarqueurs clés pour les 138 individus (palette `inferno`).
  - **Barplot des loadings :** Top 10 mâles, top 10 femelles et position de *REM16*.
- **Sortie générée :**
  - [`figure/combined_sex_markers_plot.png`](../figure/combined_sex_markers_plot.png) : Figure composite 2 panneaux.

---

### 5. Volcano Plot
- **Méthodologie statistique :**
  - Tests $t$ de Welch appliqués indépendamment sur les **20 500 gènes**.
  - Ajustement des valeurs $p$ pour tests multiples par le taux de faux positifs (**FDR**, méthode Benjamini-Hochberg).
  - Calcul de la différence moyenne d'expression ($\Delta = \bar{X}_{Femelles} - \bar{X}_{Mâles}$).
- **Seuils décisionnels :**
  - $|\Delta| > 1.0$ (changement d'expression biologique significatif).
  - $p_{\text{adj}} < 0.05$ (seuil de significativité).
- **Observation :**
  - *REM16* ressort comme le gène le plus significativement surexprimé chez les femelles.
  - Le gène *LOC133032448* ressort comme le marqueur mâle opposé le plus significatif.
- **Sortie générée :**
  - [`figure/volcano_plot.png`](../figure/volcano_plot.png) : Nuage de points annoté mettant en valeur *REM16* et *LOC133032448*.
---

## Figures produites

| Fichier figure | Description | Question ciblée |
| :--- | :--- | :--- |
| [`REM16_exp_graph.png`](../figure/REM16_exp_graph.png) | Expression de *REM16* selon le sexe biologique ($t$-test) | Q3.1 |
| [`F1_exp_graph.png`](../figure/F1_exp_graph.png) | Expression de *FT1 / F1* selon le sexe biologique ($t$-test) | Q3.1 |
| [`exp_graph.png`](../figure/exp_graph.png) | Comparaison combinée des 4 catégories (Locus & Sexe) | Q3.1 |
| [`pca_graph.png`](../figure/pca_graph.png) | Analyse en composantes principales des 138 échantillons | Q3.2 |
| [`combined_sex_markers_plot.png`](../figure/combined_sex_markers_plot.png) | Heatmap Top 50 gènes et Barplot des loadings PC2 | Q3.2 |
| [`volcano_plot.png`](../figure/volcano_plot.png) | Criblage différentiel des 20 500 gènes (FDR & Diff) | Q3.3 |
