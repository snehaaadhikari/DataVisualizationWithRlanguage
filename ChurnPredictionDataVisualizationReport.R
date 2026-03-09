# =================================================================
# PROJECT: Bank Customer Churn Analysis
# OBJECTIVE: Quantifying Churn Drivers through Data Transformation
# =================================================================

# 1. ESSENTIAL LIBRARIES & ENVIRONMENT:
library(ggplot2)
library(dplyr)
library(scales) 
library(tidyverse)

# 2. DATA IMPORT:
bank_churn_data <- read.csv("D:/DCS402/Bank Customer Churn Prediction.csv")

# Initial Inspection
glimpse(bank_churn_data)
summary(bank_churn_data) 

# -----------------------------------------------------------------
# 3. DATA CLEANING:
# -----------------------------------------------------------------

# 3.1 Null Value Assessment
missing_counts <- colSums(is.na(bank_churn_data))
missing_counts
missing_churndata <- data.frame(variable = names(missing_counts), missing = missing_counts)
missing_churndata

# 3.2 Cleaning Inconsistencies & Handling Missing Values
churn_data <- bank_churn_data %>%
  mutate(country = trimws(tolower(country)),
         gender = trimws(tolower(gender))) %>%
  distinct() %>%
  na.omit() 

# 3.3 Outlier Detection: Credit Score
Q1 <- quantile(churn_data$credit_score, 0.25)
Q3 <- quantile(churn_data$credit_score, 0.75)
IQR_val <- Q3 - Q1

# Filtering Outliers
churn_clean <- churn_data %>%
  filter(credit_score >= (Q1 - 1.5 * IQR_val) & 
           credit_score <= (Q3 + 1.5 * IQR_val))

# Visualizing Outlier Removal
 
ggplot(bank_churn_data, aes(y = credit_score)) +
  geom_boxplot(fill = "lightblue", outlier.color = "red") +
  labs(title = "Credit Score: Before Outlier Removal") + theme_minimal()

ggplot(churn_clean, aes(y = credit_score)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Credit Score: Post-Cleaning (IQR Method)") + theme_minimal()

# -----------------------------------------------------------------
# 4. DATA TRANSFORMATION: 
# -----------------------------------------------------------------
churn_final <- churn_clean %>%
  mutate(
    log_salary = log10(estimated_salary + 1),
    scaled_salary = (estimated_salary - min(estimated_salary)) / 
      (max(estimated_salary) - min(estimated_salary)),
    z_age = as.numeric(scale(age))
  )

# Create a long-format version ONLY for the comparison plot
churn_plots_long <- churn_final %>%
  pivot_longer(
    cols = c(log_salary, scaled_salary), 
    names_to = "method", 
    values_to = "transformed_value"
  )

# Visualization of Transformations
ggplot(churn_plots_long, aes(x = transformed_value, fill = method)) +
  geom_histogram(bins = 30, color = "white", show.legend = FALSE) +
  facet_wrap(~method, scales = "free") +
  theme_minimal() +
  scale_fill_manual(values = c("log_salary" = "darkgreen", "scaled_salary" = "steelblue")) +
  labs(title = "Comparison of Salary Transformations", x = "Value", y = "Frequency")

# -----------------------------------------------------------------
# 5. EXPLORATORY DATA ANALYSIS (EDA)
# -----------------------------------------------------------------
churn_summary <- churn_final %>%
  group_by(country) %>%
  summarise(
    churn_rate = mean(churn, na.rm = TRUE) * 100,
    customer_count = n(),
    avg_balance = mean(balance, na.rm = TRUE)
  ) %>%
  arrange(desc(churn_rate))

# Insight Plot: Churn Geography
ggplot(churn_summary, aes(x = reorder(country, -churn_rate), y = churn_rate)) +
  geom_bar(stat = "identity", fill = "lightpink", width = 0.6) +
  geom_text(aes(label = paste0(round(churn_rate, 1), "%")), vjust = -0.5) +
  labs(title = "Churn Rate by Country", x = "Country", y = "Churn Rate (%)") +
  theme_minimal()

# -----------------------------------------------------------------
# 6. STATISTICAL MODELING & CORRELATION
# -----------------------------------------------------------------

# Linear Regression 
model <- lm(balance ~ age + credit_score + country, data = churn_final)
summary(model)

# Correlation Heatmap
# 
numeric_cols <- churn_final %>% 
  select(credit_score, age, balance, estimated_salary, log_salary)

cor_matrix <- cor(numeric_cols, use = "complete.obs")
cor_df <- as.data.frame(as.table(cor_matrix))

ggplot(cor_df, aes(x = Var1, y = Var2, fill = Freq)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
  geom_text(aes(label = round(Freq, 2)), color = "black") +
  labs(title = "Correlation Heatmap", subtitle = "Identifying Multicollinearity") +
  theme_minimal() + 
  coord_fixed()
