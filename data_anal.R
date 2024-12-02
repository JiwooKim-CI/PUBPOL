# This code is for the main analysis after the data cleaning.

# Load required packages.

library(readr)
library(tidyverse)
library(haven)
library(ivreg)
library("modelsummary")
library(ggplot2)

url <- "https://raw.githubusercontent.com/JiwooKim-CI/PUBPOL/main/PUBPOL6090_ACS2000CENSUS.dta"
temp_file <- tempfile(fileext = ".dta")
download.file(url, temp_file, mode = "wb")  
acs <- read_dta(temp_file)

unlink(temp_file)
url <- "https://raw.githubusercontent.com/JiwooKim-CI/PUBPOL/a7263eef043571358d8bff3b07272a8da5e12cda/PUBPOL6090_analysis_data.dta"

temp_file <- tempfile(fileext = ".dta")
download.file(url, temp_file, mode = "wb") 

data <- read_dta(temp_file)

# merge data
acs$fips <- paste0(as.character(acs$statea), as.character(acs$countya)) |>
  as.numeric()

project <- left_join(data, acs, by = "fips")

# IV analysis without covariates
# We use two independent variables for this analysis; 
# disswb(Black/White Dissimilarity Index)
# exposurewb(Black/White Exposure Index)
# Also we put avg_black_inc(Average black incarceration) to see the interaction.

# For more clear interpretation, we multiply 100 to the 
# avg_black_inc_p(Average black incarceration proportion) and make a new data
# avg_black_inc(Average black incarceration)
project$avg_black_inc <- project$avg_black_inc_p*100

# First stage analysis
First_dis <- lm(disswb ~ herf, data = project)
summary(First_dis)

First_exp <- lm(exposurewb ~ herf, data = project)
summary(First_exp)

First_list <- list(Dissimilarity = First_dis, Exposure = First_exp)

first_stage <- msummary(First_list,
              stars = TRUE)
first_stage@table_dataframe[3,1]<- "Railroad Index"
first_stage@names[2] <- "Model (1)"
first_stage@names[3] <- "Model (2)"

new_order <- c(3, 4, 1, 2, 5, 6, 7, 8, 9, 10, 11, 12) 
first_stage@table_dataframe <- first_stage@table_dataframe[new_order, ]
first_stage
# IV model using disswb(Black/White Dissimilarity Index) as an independent variable
model1 <- ivreg(kfr_black_male_p25_1992  ~ disswb * avg_black_inc |
                  herf * avg_black_inc, data = project)

summary(model1)


# IV model using exposurewb(Black/White Exposure Index) as an independent variable
model2 <- ivreg(kfr_black_male_p25_1992  ~ exposurewb * avg_black_inc |
                  herf * avg_black_inc, data = project)

summary(model2)

# OLS model using disswb(Black/White Dissimilarity Index) as an independent variable
ols1 <- lm(kfr_black_male_p25_1992  ~ disswb * avg_black_inc, data = project)
summary(ols1)

# OLS model using exposurewb(Black/White Exposure Index) as an independent variable
ols2 <- lm(kfr_black_male_p25_1992  ~ exposurewb * avg_black_inc, data = project)
summary(ols2)


# To make a tidy table, we make a list with both analyses.
m_list <- list(Dissimilarity_IV = model1, Exposure_IV = model2,
               Dissimilarity_OLS = ols1, Exposure_OLS = ols2)

a <- msummary(m_list,
              stars = TRUE)

# change the column and row name.
a@table_dataframe[3,1]<- "Black/White Dissimilarity Index"
a@table_dataframe[5,1] <- "Average black incarceration"
a@table_dataframe[7,1] <- "Black/White Dissimilarity Index*Average black incarceration"
a@table_dataframe[9,1] <- "White/Black Exposure Index"
a@table_dataframe[11,1] <- "White/Black Exposure Index*Average black incarceration"

# change the rows order
new_order <- c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 13, 14,
               15, 16) 
a@table_dataframe <- a@table_dataframe[new_order, ]

a@notes[[2]] <- "All results are reported at the percentile level. We used the railroad division index as our instrumental variable."
a@names[2] <- "Model (1)-IV"
a@names[3] <- "Model (2)-IV"
a@names[4] <- "Model (1)-OLS"
a@names[5] <- "Model (2)-OLS"

# print the table
a


# Below are the IV analysis with covariates and OLS estimation.
# We use similar coding strategy for other analyses as well.

# IV analysis with covariates
project <- project |>
  mutate(
    city = substr(cityname, 1, nchar(cityname) - 2),
    state = substr(cityname, nchar(cityname) - 1, nchar(cityname))
  )


southern_states <- c("wa","mi","me")

project <- project |>
  mutate(southern = ifelse(state %in% southern_states, 1, 0))




model1_cov <- ivreg(kfr_black_male_p25_1992  ~ disswb * avg_black_inc + black_count +
                      employment_rate + poverty_rate + college_or_more |
                      herf * avg_black_inc + black_count +
                      employment_rate + poverty_rate + college_or_more,
                    data = project)

summary(model1_cov)


model2_cov <- ivreg(kfr_black_male_p25_1992  ~ exposurewb * avg_black_inc + black_count +
                      employment_rate + poverty_rate + college_or_more |
                      herf * avg_black_inc + black_count +
                      employment_rate + poverty_rate + college_or_more,
                    data = project)

summary(model2_cov)

# OLS model using disswb(Black/White Dissimilarity Index) as an independent variable
ols1_cov <- lm(kfr_black_male_p25_1992  ~ disswb * avg_black_inc + black_count +
             employment_rate + poverty_rate + college_or_more, 
           data = project)
summary(ols1_cov)

# OLS model using exposurewb(Black/White Exposure Index) as an independent variable
ols2_cov <- lm(kfr_black_male_p25_1992  ~ exposurewb * avg_black_inc + black_count +
             employment_rate + poverty_rate + college_or_more, 
           data = project)
summary(ols2_cov)


# To make a tidy table, we make a list with both analyses.



m_list_2 <- list(Dissimilarity_IV = model1_cov, Exposure_IV = model2_cov,
                 Dissimilarity_OLS = ols1_cov, Exposure_OLS = ols2_cov)

a <- msummary(m_list_2,
              stars = TRUE)
a@table_dataframe[3,1]<- "Black/White Dissimilarity Index"
a@table_dataframe[5,1] <- "Average black incarceration"
a@table_dataframe[7,1] <- "Black count"
a@table_dataframe[9,1] <- "Employment rate"
a@table_dataframe[11,1] <- "Poverty rate"
a@table_dataframe[13,1] <- "College degree or more"
a@table_dataframe[15,1] <- "Black/White Dissimilarity Index*Average black incarceration"
a@table_dataframe[17,1] <- "White/Black Exposure Index"
a@table_dataframe[19,1] <- "White/Black Exposure Index*Average black incarceration"

new_order <- c(3, 4, 5, 6, 15, 16, 17, 18, 19, 20, 7, 8, 9, 10, 11, 12, 13, 14, 
                1, 2, 21, 22, 23, 24, 25, 26, 27, 28) 
a@table_dataframe <- a@table_dataframe[new_order, ]

a@notes[[2]] <- "All results are reported at the percentile level. We used the railroad division index as our instrumental variable. This result is obtained after controlling for covariates."
a@names[2] <- "Model (1)-IV"
a@names[3] <- "Model (2)-IV"
a@names[4] <- "Model (1)-OLS"
a@names[5] <- "Model (2)-OLS"
a

## Robustness check
robust <- project |>
  filter(project$southern == 1)

model1_rob <- ivreg(kfr_black_male_p25_1992  ~ disswb * avg_black_inc |
                  herf * avg_black_inc, data = robust)
summary(model1_rob)
model2_rob <- ivreg(kfr_black_male_p25_1992  ~ exposurewb * avg_black_inc |
                      herf * avg_black_inc, data = robust)
summary(model2_rob)

m_list_rob <- list(Dissimilarity_IV = model1_rob, Exposure_IV = model2_rob)

a <- msummary(m_list_rob,
              stars = TRUE)
a@table_dataframe[3,1]<- "Black/White Dissimilarity Index"
a@table_dataframe[5,1] <- "Average black incarceration"
a@table_dataframe[7,1] <- "Black/White Dissimilarity Index*Average black incarceration"
a@table_dataframe[9,1] <- "White/Black Exposure Index"
a@table_dataframe[11,1] <- "White/Black Exposure Index*Average black incarceration"

# change the rows order
new_order <- c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 13, 14,
               15, 16) 
a@table_dataframe <- a@table_dataframe[new_order, ]

a@notes[[2]] <- "All results are reported at the percentile level. We used the railroad division index as our instrumental variable and we filter the states that are further from South."
a@names[2] <- "Model (1)-IV"
a@names[3] <- "Model (2)-IV"
a
