# BVG-7003 — Devoir 1

[![Language: R](https://img.shields.io/badge/Language-R_%E2%89%A5_4.0-276DC3?logo=r&logoColor=white)](https://www.r-project.org/)
[![Course: BVG-7003](https://img.shields.io/badge/Cours-BVG--7003-2e7d32)](https://github.com/OliV-cell/Olivier_V_DEVOIR1_repertoire)
[![Analysis: RNA-Seq](https://img.shields.io/badge/Analyse-RNA--Seq-8A2BE2)](https://github.com/OliV-cell/Olivier_V_DEVOIR1_repertoire)

**Auteur :** Olivier Vermette  
**Cours :** BVG-7003 (Génomique fonctionnelle et bio-informatique végétale)  
**Session :** Automne 2026  
**Dépôt :** `Olivier_V_DEVOIR1_repertoire`

---

**Navigation rapide :** [Description](#description) • [Structure](#structure) • [Questions & Livrables](#questions) • [Prérequis & Installation](#prerequis) • [Exécution du code](#execution)

---

## <a id="description"></a>📋 Description

Ce répertoire contient l'ensemble des scripts, données, figures et réponses textuelles pour le **Devoir 1** du cours **BVG-7003**. Le devoir est composer de 4 questions : 1) Faire le README.md du répertoire, 2) Faire le résumer d'un abstract, 3) Concevoir une pipeline d'analyse de données transcriptomique chez le Cannabis et 4) Concevoir un pipeline potentiel envers le sexage à haut débit des plant de Cannabis.

---

## <a id="structure"></a>🗂️ Structure du répertoire

```text
.
├── README.md                           # Présentation générale du projet et instructions
├── Question_1/                         # Réponses et documents liés à la Question 1
├── Question_2/                         # Analyse bibliographique et résumé critique
│   └── 1_Abstract_500.md               # Version raccourcie de l'abstract (rétractations scientifiques)
├── Question_3/                         # Réponses et synthèses pour la Question 3
│   └── Fonctionnement_pipeline.md      # Explication et fonctionnement du pipeline bio-informatique
├── Question_4/                         # Proposition et réflexion pour la Question 4
│   └── proposition.md                  # Document de proposition (pipeline RT-qPCR multiplexée)
├── code/                               # Scripts d'analyse
│   └── code_question_3.r               # Script R pour le traitement RNA-Seq, tests statistiques et graphiques
├── data/                               # Données brutes et prétraitées
│   └── 2_Data_RNASeq_Cannabis_Sex.csv  # Données d'expression RNA-Seq (sexes XX vs XY)
└── figure/                             # Graphiques générés en haute résolution (300 DPI)
    ├── REM16_exp_graph.png             # Expression du gène REM16 selon le sexe
    ├── F1_exp_graph.png                # Expression du gène FT1 / F1 selon le sexe
    ├── exp_graph.png                   # Comparaison des 4 catégories (Locus & Sexe)
    ├── pca_graph.png                   # Analyse en composantes principales (PCA) des échantillons
    ├── volcano_plot.png                # Volcano plot de l'expression différentielle globale
    └── combined_sex_markers_plot.png   # Figure combinée multi-panneaux des marqueurs de sexe
```

---

## <a id="questions"></a>🔬 Résumé des questions et analyses

### Question 1 : Initialisation du dépôt
- Configuration du dépôt GitHub personnel, organisation des dossiers et suivi de version Git (`Question_1/README.md`).

### Question 2 : Analyse d'un abstract scientifique
- Synthèse et condensation à moins de 500 mots d'une étude portant sur la dynamique temporelle et les causes des rétractations d'articles scientifiques indexés sur PubMed (`Question_2/1_Abstract_500.md`).

### Question 3 : Analyse RNA-Seq et déterminisme sexuel (*Cannabis sativa*)
- **Objectif :** Évaluer l'expression différentielle de gènes candidats selon le sexe biologique (Femelles XX vs Mâles XY) sur un jeu de 138 échantillons.
- **Gènes ciblés :**
  - **REM16** (`LOC115699937`) : Impliqué dans le développement du méristème reproducteur.
  - **FT1 / F1** (`LOC115696989`) : Homologue de *Flowering Locus T*.
- **Démarche statistique & bio-informatique :**
  1. Classification automatique des échantillons (XX vs XY).
  2. Vérification des postulats (tests de normalité et test d'homogénéité des variances de Levene avec `car`).
  3. Tests statistiques ($t$-test bilatéral, ANOVA et comparaisons multiples).
  4. Visualisations de qualité publication avec `ggplot2` et `ggpubr` (boxplots, superposition des points individuels, et barres de significativité).

### Question 4 : Proposition
- Conception d'un pipeline de sexage précoce à haut débit basé sur une RT-qPCR multiplexée ciblant le ratio d'expression `REM16` / `lncREM16` (`LOC133032448`) sur méristèmes apicaux (`Question_4/proposition.md`).

---

## <a id="prerequis"></a> Prérequis et installation

Pour exécuter les scripts du projet, assurez-vous d'avoir installé **R (version $\ge$ 4.0)** ainsi que les bibliothèques suivantes :

```r
install.packages(c("ggplot2", "ggpubr", "tidyr", "car", "scales"))
```
 *(Le package `grid` est quant à lui inclus nativement dans R).*

---

## <a id="execution"></a> Exécution du code

1. **Cloner le dépôt et se placer dans le répertoire :**
```bash
git clone https://github.com/OliV-cell/Olivier_V_DEVOIR1_repertoire.git
cd Olivier_V_DEVOIR1_repertoire
```

2. **Lancer le script d'analyse :**
À l'interieur de R, il vous suffira de metre la direction de travail au répertoire
```bash
setwd("")
Rscript code/code_question_3.r
```

Les figures seront déja affichées et générées dans le dossier `figure/`.

