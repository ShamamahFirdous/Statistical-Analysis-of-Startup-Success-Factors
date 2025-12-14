###############################################################################
# PHASE 1 — DATA LOADING, CLEANING & PREPROCESSING
# INFO6105 FINAL PROJECT — Startup Success Analysis
###############################################################################

# ------------------------------------------------------------
# 1. Loading Required Libraries
# ------------------------------------------------------------
library(readr)       # For read_csv()
library(dplyr)       # For data manipulation
library(ggplot2)     # For plots (later phases)
library(stringr)     # For string detection & cleaning
library(car)         # For VIF (used in regression phase)
library(GGally)      # For scatterplot matrix (EDA phase)

# ------------------------------------------------------------
# 2. Load Dataset (CSV must be in the working directory)
# ------------------------------------------------------------
df <- read_csv("startup data.csv")

# Quick structure check
str(df)
summary(df)


# ------------------------------------------------------------
# 3. Clean Column Names (lowercase + snake_case)
# ------------------------------------------------------------
names(df) <- df %>% 
  names() %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_") %>% 
  str_replace_all("-", "_")


# ------------------------------------------------------------
# 4. Select Only Relevant Variables for Analysis
# ------------------------------------------------------------

df <- df %>% select(
  labels,
  avg_participants,
  is_top500,
  has_vc,
  has_angel,
  has_rounda,
  has_roundb,
  has_roundc,
  funding_total_usd,
  funding_rounds,
  state_code,
  is_software,
  is_mobile,
  is_advertising,
  is_gamesvideo,
  is_ecommerce,
  is_biotech,
  is_consulting,
  is_othercategory
)


# ------------------------------------------------------------
# 5. Convert Response Variable to Numeric (0 = fail, 1 = success)
# ------------------------------------------------------------
df$labels <- as.numeric(df$labels)


# ------------------------------------------------------------
# 6. Create INDUSTRY GROUP Variable (Using binary indicators)
# ------------------------------------------------------------

df$industry_group <- case_when(
  df$is_software == 1 ~ "Software/IT",
  df$is_mobile == 1 ~ "Media/Platforms",
  df$is_advertising == 1 ~ "Media/Platforms",
  df$is_gamesvideo == 1 ~ "Media/Platforms",
  df$is_ecommerce == 1 ~ "Media/Platforms",
  df$is_biotech == 1 ~ "Biotech",
  df$is_consulting == 1 ~ "Other Tech",
  df$is_othercategory == 1 ~ "Other Tech",
  TRUE ~ "Other Tech"     # default fallback
)

df$industry_group <- as.factor(df$industry_group)

# ------------------------------------------------------------
# 7. Create REGION Variable from State Codes (For Two-way ANOVA)
# ------------------------------------------------------------
west    <- c("CA", "WA", "OR", "NV", "AZ", "ID", "UT", "CO")
east    <- c("NY", "MA", "NJ", "PA", "VA", "MD", "FL", "DC")
midwest <- c("IL", "OH", "MI", "MN", "WI", "MO")
south   <- c("TX", "GA", "NC", "SC", "TN", "AL")

df$region <- case_when(
  df$state_code %in% west    ~ "West",
  df$state_code %in% east    ~ "East",
  df$state_code %in% midwest ~ "Midwest",
  df$state_code %in% south   ~ "South",
  TRUE ~ "Other"
)

df$region <- as.factor(df$region)


# ------------------------------------------------------------
# 8. Convert Categorical Variables to Factors
# ------------------------------------------------------------
df$is_top500      <- as.factor(df$is_top500)
df$industry_group <- as.factor(df$industry_group)
df$region         <- as.factor(df$region)


# ------------------------------------------------------------
# 9. Validate Category Distribution (Required for ANOVA Assumptions)
# ------------------------------------------------------------
table(df$industry_group)
table(df$region)
table(df$region, df$industry_group)   # Must NOT be all zeros


# ------------------------------------------------------------
# 10. Summary Table of Key Variables (Peer Feedback Required)
# ------------------------------------------------------------
variable_summary <- data.frame(
  Variable = c("labels", "funding_total_usd", "funding_rounds",
               "avg_participants", "is_top500", "industry_group", "region"),
  Type = c("Numeric", "Numeric", "Numeric", "Numeric", "Factor", "Factor", "Factor"),
  Description = c("1 = success, 0 = failure",
                  "Total funds raised in USD",
                  "Number of funding rounds received",
                  "Count of investor participants",
                  "Top 500 ranking indicator",
                  "Grouped industry category",
                  "Grouped U.S. geographic region")
)

print(variable_summary)

###############################################################################
# END OF PHASE 1
###############################################################################

###############################################################################
# PHASE 2 — EXPLORATORY DATA ANALYSIS (EDA)
# INFO6105 FINAL PROJECT — Startup Success Analysis
###############################################################################
library(reshape2)
# ------------------------------------------------------------
# 1. Summary Statistics of Key Numeric Variables
# ------------------------------------------------------------
summary(df %>% select(labels, funding_total_usd, funding_rounds, avg_participants))

# View frequency of categorical variables
table(df$industry_group)
table(df$region)


# ------------------------------------------------------------
# 2. Correlation Matrix of Numeric Predictors
# ------------------------------------------------------------
numeric_vars <- df %>% select(
  labels,
  funding_total_usd,
  funding_rounds,
  avg_participants
)

cor_matrix <- cor(numeric_vars, use = "complete.obs")
cor_matrix   # display matrix

# Visual correlation heatmap
library(ggplot2)

ggplot(melt(cor_matrix), aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                       midpoint = 0, limit = c(-1, 1)) +
  theme_minimal() +
  labs(title = "Correlation Heatmap", x = "", y = "")


# ------------------------------------------------------------
# 3. Scatterplot Matrix (GGally SPLoM) — Required by Prof. Pan
# ------------------------------------------------------------
library(GGally)

GGally::ggpairs(numeric_vars,
                title = "Scatterplot Matrix of Key Quantitative Variables")


# ------------------------------------------------------------
# 4. Boxplots for Startup Success (labels) by Industry Group
# ------------------------------------------------------------
ggplot(df, aes(x = industry_group, y = labels, fill = industry_group)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Startup Success by Industry Group",
       x = "Industry Group", y = "Success (1 = success, 0 = failure)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# ------------------------------------------------------------
# 5. Boxplots for Startup Success by Region
# ------------------------------------------------------------
ggplot(df, aes(x = region, y = labels, fill = region)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Startup Success by Region",
       x = "Region", y = "Success (1 = success, 0 = failure)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# ------------------------------------------------------------
# 6. Histograms of Key Numeric Variables
# ------------------------------------------------------------

# Funding Total
ggplot(df, aes(x = funding_total_usd)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Total Funding (USD)",
       x = "Total Funding (USD)", y = "Count")

# Funding Rounds
ggplot(df, aes(x = funding_rounds)) +
  geom_histogram(bins = 30, fill = "darkgreen", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Funding Rounds",
       x = "Funding Rounds", y = "Count")


# ------------------------------------------------------------
# 7. Industry × Region Interaction — Heatmap of Mean Success
# ------------------------------------------------------------
library(tidyr)
cor_long <- cor_matrix %>%
  as.data.frame() %>%
  mutate(Var1 = rownames(.)) %>%
  pivot_longer(
    cols = -Var1,
    names_to = "Var2",
    values_to = "value"
  )
ggplot(cor_long, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(
    low = "blue", high = "red", mid = "white",
    midpoint = 0, limit = c(-1, 1)
  ) +
  theme_minimal() +
  labs(
    title = "Correlation Heatmap",
    x = "", y = ""
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


###############################################################################
# END OF PHASE 2
###############################################################################



###############################################################################
# PHASE 3 — MULTIPLE LINEAR REGRESSION
# INFO6105 FINAL PROJECT — Startup Success Analysis
###############################################################################

# ------------------------------------------------------------
# 1. Prepare Data for Regression Model
# ------------------------------------------------------------

# Convert categorical variables to factors (if not already)
df$industry_group <- as.factor(df$industry_group)
df$region <- as.factor(df$region)
df$is_top500 <- as.factor(df$is_top500)
df$has_vc <- as.factor(df$has_vc)
df$has_angel <- as.factor(df$has_angel)
df$has_rounda <- as.factor(df$has_rounda)
df$has_roundb <- as.factor(df$has_roundb)
df$has_roundc <- as.factor(df$has_roundc)

# ------------------------------------------------------------
# 2. Build the Multiple Linear Regression Model
# ------------------------------------------------------------

model <- lm(labels ~ 
              funding_total_usd +
              funding_rounds +
              avg_participants +
              is_top500 +
              has_vc +
              has_angel +
              industry_group +
              region,
            data = df)

summary(model)   # Regression output


# ------------------------------------------------------------
# 3. Multicollinearity Check (VIF)
# ------------------------------------------------------------
library(car)
vif_values <- vif(model)
vif_values

# Interpretation:
# VIF < 5  → Good
# VIF < 10 → Acceptable
# VIF >=10 → Multicollinearity problem (remove or combine predictors)


# ------------------------------------------------------------
# 4. Diagnostic Plots (Model Assumptions)
# ------------------------------------------------------------

# Residuals vs Fitted → checks linearity & homoscedasticity
plot(model, which = 1)

# Q-Q plot → checks normality of residuals
plot(model, which = 2)

# Scale-Location Plot → checks variance consistency
plot(model, which = 3)

# Cook’s Distance → identifies influential points
plot(model, which = 4)


# ------------------------------------------------------------
# 5. Extract Key Model Outputs for Reporting
# ------------------------------------------------------------

coeff_table <- summary(model)$coefficients
coeff_table

r_squared <- summary(model)$r.squared
adj_r_squared <- summary(model)$adj.r.squared

r_squared
adj_r_squared

# ------------------------------------------------------------
# 6. Clean Interpretation Guidelines
# ------------------------------------------------------------

# funding_total_usd: Positive coefficient → more funding increases success odds
# funding_rounds:   Higher rounds → often greater investor confidence
# avg_participants: More investors involved → higher success likelihood
# is_top500:        Being a top-ranked startup increases probability of success
# has_vc/angel:     Shows investor backing effect
# industry_group:   Compare industry differences vs baseline category
# region:           Compare regional effects (e.g., West vs others)

###############################################################################
# END OF PHASE 3
###############################################################################



###############################################################################
# PHASE 4 — ANOVA ANALYSIS
# INFO6105 FINAL PROJECT — Startup Success Analysis
###############################################################################
# ------------------------------------------------------------
# 1. ONE-WAY ANOVA: Success ~ Industry Group
# ------------------------------------------------------------

anova_industry <- aov(labels ~ industry_group, data = df)
summary(anova_industry)

# Summary statistics by group (REQUIRED)
df %>%
  group_by(industry_group) %>%
  summarise(
    mean_success = mean(labels),
    sd_success = sd(labels),
    n = n()
  )

# Effect size (REQUIRED for full credit)
library(DescTools)
effect_size_industry <- EtaSq(anova_industry, type = 1)
effect_size_industry

# Post-hoc test
tukey_industry <- TukeyHSD(anova_industry)
tukey_industry

# Boxplot
ggplot(df, aes(x = industry_group, y = labels, fill = industry_group)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Success by Industry Group (One-way ANOVA)",
       x = "Industry Group", y = "Success Score") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# ------------------------------------------------------------
# 3. TWO-WAY ANOVA: Success ~ Region * Industry Group
# ------------------------------------------------------------

anova_two_way <- aov(labels ~ region * industry_group, data = df)
summary(anova_two_way)

# Interaction effect is key: region:industry_group


# ------------------------------------------------------------
# 4. Interaction Plot (Visualization)
# ------------------------------------------------------------

with(df, interaction.plot(
  x.factor = industry_group,
  trace.factor = region,
  response = labels,
  type = "b",
  col = c("red", "blue", "green", "purple", "orange"),
  pch = c(16, 17, 18, 19, 20),
  main = "Interaction Plot: Region × Industry Group",
  xlab = "Industry Group",
  ylab = "Mean Success"
))


# ------------------------------------------------------------
# 5. Heatmap of Interaction Effects (Using the summary table)
# ------------------------------------------------------------

interaction_df <- df %>%
  group_by(region, industry_group) %>%
  summarise(mean_success = mean(labels), .groups = "drop")

ggplot(interaction_df, aes(x = industry_group, y = region, fill = mean_success)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightyellow", high = "darkred") +
  labs(title = "Two-Way ANOVA Interaction Heatmap",
       x = "Industry Group", y = "Region", fill = "Mean Success") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# ------------------------------------------------------------
# 6. Assumption Checks for ANOVA
# ------------------------------------------------------------

# Normality of residuals
resid_industry <- residuals(anova_industry)
shapiro.test(resid_industry)   # p > 0.05 → normality OK

# Homogeneity of variance (Levene’s test)
library(car)
leveneTest(labels ~ industry_group, data = df)

leveneTest(labels ~ region * industry_group, data = df)


###############################################################################
# END OF PHASE 4
###############################################################################

###############################################################
# SESSION INFORMATION (Required for Reproducibility)
###############################################################
sessionInfo()

# ==== FIGURES FOR REPORT ====
# MLR-1: Scatterplot Matrix
library(GGally)
GGally::ggpairs(df[, c("labels", "funding_total_usd", "funding_rounds", "avg_participants")],
                title = "Scatterplot Matrix of Quantitative Variables")
# MLR-2: Correlation Matrix Heatmap
library(ggplot2)
library(reshape2)

# Select numeric variables for correlation
num_vars <- df[, c("labels", "funding_total_usd", "funding_rounds", "avg_participants")]
cor_matrix <- round(cor(num_vars), 2)

# Melt for heatmap
melted_cor <- melt(cor_matrix)

# Plot heatmap
ggplot(data = melted_cor, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                       midpoint = 0, limit = c(-1,1), space = "Lab",
                       name = "Correlation") +
  geom_text(aes(label = value), color = "black", size = 4) +
  theme_minimal() +
  labs(title = "Correlation Matrix of Numeric Variables",
       x = "", y = "") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
# MLR-3 to MLR-6: Diagnostic Plots for Regression Model
par(mfrow = c(2, 2))  # 2x2 layout
plot(model)

#1
ggplot(df, aes(x = industry_group, y = labels)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Success by Industry Group", x = "Industry Group", y = "Success Label") +
  theme_minimal()

anova_industry <- aov(labels ~ industry_group, data = df)
TukeyHSD(anova_industry)
#2
# Compact letters
library(multcomp)
library(multcompView)
tukey_result <- glht(anova_industry, linfct = mcp(industry_group = "Tukey"))
cld_result <- cld(tukey_result)
plot(cld_result)
#3

library(DescTools)
EtaSq(anova_industry)
#1
# Calculate mean success by industry group and region
interaction_df <- df %>%
  group_by(industry_group, region) %>%
  summarise(mean_success = mean(labels), .groups = "drop")

# Plot heatmap
ggplot(interaction_df, aes(x = industry_group, y = region, fill = mean_success)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightyellow", high = "darkred") +
  labs(
    title = "Two-Way ANOVA Interaction Heatmap",
    x = "Industry Group",
    y = "Region",
    fill = "Mean Success"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


