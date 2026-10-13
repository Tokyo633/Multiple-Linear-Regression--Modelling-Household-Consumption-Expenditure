

#Lab Assignment

setwd("C:/Users/grace/OneDrive/Documents/School Stuff/Semester 4/Advanced Regression/Lab 1 assignment")
df <- read.csv("economics.csv")
View(df)

# ============================================================
# STEP 1: Baseline Multiple Linear Regression
# ============================================================

library(tidyverse)  

# --- Load data ---
df <- read.csv("economics.csv", stringsAsFactors = FALSE)
df
# Set Region as a factor with Midwest as reference level
df$Region <- factor(df$Region, levels = c("Midwest", "Northeast", "South", "West"))

str(df)
summary(df)

# --- Fit the baseline model ---


model_A <- lm(Household_Consumption_K ~ Household_Income_K + Household_Wealth_K +
                Interest_Rate_Pct + Mortgage_Rate_Pct + Consumer_Confidence_Index +
                Unemployment_Rate_Pct + Years_of_Education + Local_Stock_Index_Return_Pct +
                Region,
              data = df)

summary(model_A)

# --- Key fit statistics ---
cat("R-squared:", summary(model_A)$r.squared, "\n")
cat("Adjusted R-squared:", summary(model_A)$adj.r.squared, "\n")
cat("RMSE:", sqrt(mean(residuals(model_A)^2)), "\n")
cat("AIC:", AIC(model_A), "\n")
cat("BIC:", BIC(model_A), "\n")

# --- Coefficient table with confidence intervals ---
confint(model_A) 




# STEP 2a: Backward Selection


model_full <- lm(Household_Consumption_K ~ Household_Income_K + Household_Wealth_K +
                   Interest_Rate_Pct + Mortgage_Rate_Pct + Consumer_Confidence_Index +
                   Unemployment_Rate_Pct + Years_of_Education + Local_Stock_Index_Return_Pct +
                   Region,
                 data = df)

model_backward <- step(model_full,
                       direction = "backward",
                       trace = TRUE)   

summary(model_backward)
AIC(model_backward)
BIC(model_backward)



# STEP 2b: Forward Selection


model_null <- lm(Household_Consumption_K ~ 1, data = df)

model_full <- lm(Household_Consumption_K ~ Household_Income_K + Household_Wealth_K +
                   Interest_Rate_Pct + Mortgage_Rate_Pct + Consumer_Confidence_Index +
                   Unemployment_Rate_Pct + Years_of_Education + Local_Stock_Index_Return_Pct +
                   Region,
                 data = df)

model_forward <- step(model_null,
                      scope = list(lower = model_null, upper = model_full),
                      direction = "forward",
                      trace = TRUE)

summary(model_forward)
AIC(model_forward)
BIC(model_forward)

# Model Diagnostic

library(lmtest)
library(car)
install.packages("tseries")
library(tseries)

model_selected <- lm(Household_Consumption_K ~ Household_Income_K + Household_Wealth_K +
                       Interest_Rate_Pct + Mortgage_Rate_Pct + Consumer_Confidence_Index +
                       Unemployment_Rate_Pct + Region,
                     data = df)

# 1. Linearity
plot(model_selected, which = 1)

# 2. Independence
dwtest(model_selected)

# 3. Homoscedasticity
bptest(model_selected)
plot(model_selected, which = 3)

# 4. Normality
plot(model_selected, which = 2)
jarque.bera.test(residuals(model_selected))
shapiro.test(residuals(model_selected))

# 5. Multicollinearity
vif(model_selected)

# 6. Outliers and influence
plot(model_selected, which = 4)
std_resid <- rstandard(model_selected)
df[abs(std_resid) > 3, ]


