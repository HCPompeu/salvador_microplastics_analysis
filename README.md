# Salvador Microplastics Statistical Analysis
R-based statistical analysis of putative microplastic particle counts in marine organisms from the coastal region of Salvador, Bahia, Brazil.

The workflow was developed for the manuscript *Occurrence and Morphological Characterization of Putative Microplastic Particles in Marine Organisms from the Coastal Region of Salvador, Bahia, Brazil*. It covers data validation, descriptive statistics, non-parametric hypothesis testing, figure generation, and export of statistical tables.

## Analysis overview
The script implements the following analyses:

- Data import and validation, including checks for required columns, missing values, trophic-level categories, and consistency between total and fraction-specific particle counts.
- Descriptive statistics, reporting sample sizes and medians with first and third quartiles by trophic level.
- Kruskal–Wallis tests to compare particle counts across trophic levels for the floating and decanted fractions.
- Dunn's post-hoc test with Bonferroni adjustment for pairwise comparisons in the floating fraction.
- Boxplot generation to visualize particle counts across trophic levels and analytical fractions.
- Export of statistical tables in CSV and XLSX formats.

## Results
The workflow generates the following outputs:

| Output | Description |
| --- | --- |
| `Figure_1_particle_counts.tiff` | Boxplot of particle counts by trophic level and analytical fraction, exported at 600 dpi. |
| `Table_1_Descriptive.csv` | Descriptive statistics for the floating and decanted fractions. |
| `Table_2_Kruskal_Wallis.csv` | Kruskal–Wallis test statistics and p-values for both fractions. |
| `Table_3_Dunn_Floating.csv` | Pairwise Dunn's test results for the floating fraction, including unadjusted and Bonferroni-adjusted p-values. |
| `Microplastics_final_tables.xlsx` | Excel workbook containing the three statistical tables. |

The script creates the output directories when needed and saves the generated files under `results/`.

## How to reproduce
### Requirements
- R 4.6.1
- RStudio (recommended)
- The R packages listed below

```r
install.packages(c('dplyr','tidyr','ggplot2','FSA','openxlsx','here'))
```

### Run the analysis
1. Clone or download this repository.
2. Open `salvador-microplastics-statistical-analysis.Rproj` in RStudio.
3. Open `scripts/statistical_analysis.R`.
4. Ensure the required packages are installed.
5. Run the script.

The workflow uses the `here` package to resolve file paths relative to the project directory. The input file `data/mp_data.csv` must be available in the expected location.

## Repository layout
```text
salvador-microplastics-statistical-analysis/
├── data/
│   ├── mp_data.csv
│   └── nt_morf_col.csv
├── results/
│   ├── figures/
│   └── tables/
├── scripts/
│   └── statistical_analysis.R
├── .gitignore
├── LICENSE
├── README.md
└── salvador-microplastics-statistical-analysis.Rproj
```

- `data/` contains the datasets associated with the study.
- `scripts/` contains the R script implementing the statistical workflow.
- `results/figures/` stores the generated figure.
- `results/tables/` stores the exported statistical tables.

The dataset `nt_morf_col.csv` contains morphology and color data. It is included in the repository but is not processed by the statistical script described here.

## Data interpretation and limitations
The particle counts analyzed by the script correspond to particles observed in six microscope-slide drops per specimen. They should not be interpreted as total particle burden, particle concentration per gram of tissue, or estimates of the total number of particles present in each organism.

The particles are described as **putative microplastics** because identification was based on morphological and visual characteristics. Spectroscopic or chemical analyses to confirm polymer composition were not performed.

The script covers the statistical workflow described above. Sampling procedures, laboratory methods, the rationale for the statistical analyses, and the interpretation of the findings are addressed in the associated manuscript.

## Associated manuscript
**Occurrence and Morphological Characterization of Putative Microplastic Particles in Marine Organisms from the Coastal Region of Salvador, Bahia, Brazil**

Publication and citation details will be added when available.

## License
See [`LICENSE`](LICENSE) for the terms governing the use, modification, and redistribution of the materials covered by the license.
