# Modelling Household Consumption Expenditure

A multiple linear regression analysis identifying which economic and financial factors
explain variation in household consumption expenditure, fitted in R.

## Overview

**Sample:** 500 households · **Outcome:** `Household_Consumption_K` · **Predictors:** 8 numeric + Region

| Variable | Description |
|---|---|
| `Household_Income_K` | Annual household income ($000s) |
| `Household_Wealth_K` | Household net wealth ($000s) |
| `Interest_Rate_Pct` | Benchmark interest rate (%) |
| `Mortgage_Rate_Pct` | Mortgage rate (%) |
| `Consumer_Confidence_Index` | Consumer confidence score |
| `Unemployment_Rate_Pct` | Local unemployment rate (%) |
| `Years_of_Education` | Years of formal education |
| `Local_Stock_Index_Return_Pct` | Local stock index return (%) |
| `Region` | Northeast, Midwest, South, West (Midwest = reference) |

## Method

1. **Baseline model** — all predictors, `lm()`
2. **Variable selection** — forward and backward stepwise by AIC
3. **Diagnostics** — linearity, Durbin-Watson, Breusch-Pagan, Shapiro-Wilk, VIF, Cook's distance

## Results

**Selected model:** forward and backward selection converged on the same seven predictors,
dropping `Years_of_Education` and `Local_Stock_Index_Return_Pct`.

| Metric | Full model | Selected model |
|---|---|---|
| R² | 0.8091 | 0.8085 |
| Adjusted R² | 0.8047 | **0.8050** |
| AIC | 4264.0 | **4261.4** |
| BIC | 4318.8 | **4307.8** |
| RSE | 16.97 | 16.96 |

Removing the two predictors cost almost nothing in fit while improving adjusted R² and both
information criteria — indicating they contributed more noise than signal.

**Significant predictors:** Household Income (+0.504), Household Wealth (+0.123) and Consumer
Confidence (+0.723) raise consumption; Mortgage Rate (−4.99), Unemployment Rate (−2.37),
Interest Rate (−2.20) and Region (South +11.83, West +21.72 vs Midwest) are also significant.

## Diagnostics

| Assumption | Test | Result | Verdict |
|---|---|---|---|
| Linearity | Residuals vs Fitted | Flat smoother | ✅ |
| Independence | Durbin-Watson | DW = 1.9993, p = 0.4975 | ✅ |
| Homoscedasticity | Breusch-Pagan | BP = 14.26, df = 9, p = 0.1135 | ✅ |
| Normality | Shapiro-Wilk | W = 0.851, p < 2.2e-16 | ❌ |
| Multicollinearity | VIF | max ≈ 1.86 | ✅ |

Normality fails due to heavy tails — driven by a small number of outlier households
(observations 44, 95, 366) that the Q-Q plot shows flying off at both extremes while the
centre tracks the reference line. Coefficients remain unbiased; inference is affected.

## Files

| File | Description |
|---|---|
| `economics.csv` | Source dataset (500 households) |
| `analysis.R` | Full pipeline — baseline, selection, diagnostics |

## Requirements

```r
install.packages(c("tidyverse", "lmtest", "car", "tseries"))

