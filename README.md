# Statistical-Analysis-of-Startup-Success-Factors
Statistical analysis of 923 tech startups using Multiple Linear Regression and ANOVA in R to identify success predictors. Discovered that funding rounds and investor participation outweigh total capital. Includes comprehensive visualizations and actionable insights.
[![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)
[![RStudio](https://img.shields.io/badge/RStudio-75AADB?style=for-the-badge&logo=rstudio&logoColor=white)](https://www.rstudio.com/)

A comprehensive statistical analysis of 923 technology startups using Multiple Linear Regression and ANOVA to identify key predictors of success in the tech industry.

## 📊 Overview

This research project investigates quantitative factors influencing startup success, analyzing funding patterns, investor participation, industry type, and geographic region to provide data-driven insights for founders, investors, and policymakers.

### 🎯 Key Findings

- **Funding structure > Funding amount**: Number of funding rounds and investor participation are stronger predictors than total capital raised
- **Top 500 ranking**: Significantly increases probability of success (p < .001)
- **Industry differences**: Software/IT startups show statistically significant advantage
- **Geographic patterns**: Western region startups demonstrate slightly higher success rates
- **Independent effects**: Industry and region influence success without significant interaction

## 🛠️ Technologies & Methods

**Statistical Techniques:**
- Multiple Linear Regression (R² = 0.157, p < .001)
- One-Way ANOVA (Industry comparison)
- Two-Way ANOVA (Industry × Region interaction)
- Tukey HSD post-hoc analysis

**R Packages:**
- Data: `readr`, `dplyr`, `stringr`
- Visualization: `ggplot2`, `GGally`
- Analysis: `car`, `DescTools`, `multcomp`

## 📁 Dataset

- **Source**: [Kaggle - Startup Success Prediction](https://www.kaggle.com/datasets/manishkc06/startup-success-prediction)
- **Size**: 923 U.S.-based tech startups
- **Key Variables**: funding_total_usd, funding_rounds, avg_participants, industry_group, region, is_top500

## 🚀 Getting Started

### Installation
```r
# Install required packages
install.packages(c("readr", "dplyr", "ggplot2", "stringr", 
                   "car", "GGally", "DescTools", "multcomp"))
```

### Running the Analysis
```bash
# Clone repository
git clone https://github.com/ShamamahFirdous/Statistical-Analysis-of-Startup-Success-Factors.git
cd Statistical-Analysis-of-Startup-Success-Factors

# Download dataset from Kaggle and place in project root
# Run analysis in R
source("analysis.R")
```

## 📂 Project Structure
```
Statistical-Analysis-of-Startup-Success-Factors/
│
├── data/                    # Dataset (download from Kaggle)
├── scripts/                 # R analysis scripts
├── outputs/figures/         # Visualizations
├── report/                  # Full project report (PDF)
├── analysis.R              # Main analysis script
└── README.md
```

## 📊 Results Summary

### Regression Findings
| Predictor | p-value | Result |
|-----------|---------|--------|
| Funding Rounds | < .001 | **Strong predictor** ✓ |
| Avg Participants | < .01 | **Significant** ✓ |
| Top 500 Ranking | < .001 | **Large positive effect** ✓ |
| Total Funding | .93 | Not significant ✗ |

### ANOVA Findings
- **Industry Effect**: Significant (p < .05) - Software/IT shows advantage
- **Regional Effect**: Mild influence - Western startups perform better
- **Interaction**: Not significant - effects act independently

## 💡 Key Insights

**For Founders:**
- Prioritize multiple funding rounds over single large investments
- Build diverse investor networks
- Seek credibility markers (rankings, accelerators)

**For Investors:**
- Evaluate funding structure and investor engagement
- Consider industry-specific success patterns
- Factor in regional ecosystem strengths

## 🎓 Academic Context

**Course**: INFO 6105 - Data Science Engineering Methods and Tools  
**Institution**: Northeastern University  
**Professor**: Hong Pan, PhD  
**Semester**: Fall 2025

## 📄 Documentation

- **Full Report**: [View PDF](./report/Final_Project_Report.pdf)

## 🔬 Statistical Rigor

**Assumptions Validated:**
- ✅ Linearity, Independence, Homoscedasticity (Levene's test: p > .05)
- ✅ Normality (Shapiro-Wilk test: p > .05)
- ✅ No Multicollinearity (VIF < 3)

**Limitations:**
- Limited to U.S.-based tech startups
- Binary success label may oversimplify outcomes
- Moderate R² suggests unmeasured factors exist

## 📧 Contact

**Shamamah Firdous**
- Email: firdous.s@northeastern.edu
- LinkedIn: [linkedin.com/in/shamamah-firdous-867181306](https://linkedin.com/in/shamamah-firdous-867181306)
- GitHub: [@ShamamahFirdous](https://github.com/ShamamahFirdous)
- Location: Boston, MA

## 🙏 Acknowledgments

- **Dataset**: [Manish KC - Kaggle](https://www.kaggle.com/datasets/manishkc06/startup-success-prediction)
- **R Packages**: Wickham et al. (ggplot2, dplyr), Fox & Friendly (car)
- **Course**: INFO 6105 at Northeastern University

---

⭐ **If you found this analysis helpful, please give it a star!**

**Note**: This is an academic research project. Results should not be considered professional investment advice.
