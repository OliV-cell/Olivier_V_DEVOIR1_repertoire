# BVG-7003 — Devoir 1

**Auteur :** Olivier Vermette  
**Cours :** BVG-7003 (Génomique fonctionnelle et bio-informatique végétale)  
**Session :** Automne 2026  
**Dépôt :** `Olivier_V_DEVOIR1_repertoire`

---

## 📋 Description du projet

Ce dépôt contient l'ensemble des scripts, données, figures et réponses textuelles pour le **Devoir 1** du cours **BVG-7003**. Le projet aborde l'analyse critique de publications scientifiques ainsi que l'exploration bio-informatique et statistique de données RNA-Seq chez *Cannabis sativa* pour l'étude du déterminisme sexuel.

---

## 🗂️ Structure du répertoire

```text
.
├── README.md               # Présentation générale du projet et instructions
├── Question_1/             # Réponses et documents liés à la Question 1
├── Question_2/             # Analyse bibliographique et résumé critique
│   └── 1_Abstract_500.md   # Version raccourcie de l'abstract (rétractations scientifiques)
├── Question_3/             # Réponses et synthèses pour la Question 3
├── Question_4/             # Proposition et réflexion pour la Question 4
│   └── proposition.md      # Document de proposition
├── code/                   # Scripts d'analyse
│   └── code_question_3.r   # Script R pour le traitement RNA-Seq, tests statistiques et graphiques
├── data/                   # Données brutes et prétraitées
│   └── 2_Data_RNASeq_Cannabis_Sex.csv  # Données d'expression RNA-Seq (sexes XX vs XY)
└── figure/                 # Graphiques générés en haute résolution (300 DPI)
    ├── REM16_exp_graph.png # Expression du gène REM16 selon le sexe
    ├── F1_exp_graph.png    # Expression du gène FT1 / F1 selon le sexe
    └── exp_graph.png       # Comparaison des 4 catégories (Locus & Sexe)
```

---

## 🔬 Résumé des questions et analyses

### Question 1
- *[À compléter : Brève description du livrable]*

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

## ⚙️ Prérequis et installation

Pour exécuter les scripts du projet, assurez-vous d'avoir installé **R (version $\ge$ 4.0)** ainsi que les bibliothèques suivantes :

```r
install.packages(c("ggplot2", "ggpubr", "tidyr", "car", "scales"))
```
*(Le package `grid` est quant à lui inclus nativement dans R).*

---

## Exécution du code

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

Les figures seront affichées et générées directement dans le dossier `figure/`.

