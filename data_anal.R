# This code is for the main analysis after the data cleaning.

## Package loading

required_packages <- c("readr", "tidyverse", "haven", "ivreg", "modelsummary", "ggplot2")

# install package and loading
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE) # install package
    library(pkg, character.only = TRUE)       # install and load
  } else {
    library(pkg, character.only = TRUE)       
  }
}


project <- read_dta("https://github.com/JiwooKim-CI/PUBPOL/blob/232465b3a6da22efcb68d8cb2747e1f4eb305d3c/aej_atlas_FIPS_incarceration_final.dta")

# IV analysis without covariates
project$avg_black_inc <- project$avg_black_inc_p*100


model1 <- ivreg(kfr_black_male_p25_1992  ~ disswb * avg_black_inc |
                  herf * avg_black_inc, data = project)

summary(model1)


model2 <- ivreg(kfr_black_male_p25_1992  ~ exposurewb * avg_black_inc |
                  herf * avg_black_inc, data = project)

summary(model2)



m_list <- list(Dissimilarity = model1, Exposure = model2)

a <- msummary(m_list,
              stars = TRUE)
a@table_dataframe[3,1]<- "Black/White Dissimilarity Index"
a@table_dataframe[5,1] <- "Average black incarceration"
a@table_dataframe[7,1] <- "Black/White Dissimilarity Index*Average black incarceration"
a@table_dataframe[9,1] <- "Black/White Exposure Index"
a@table_dataframe[11,1] <- "Black/White Exposure Index*Average black incarceration"

new_order <- c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 13, 14,
               15, 16) ## change the rows order
a@table_dataframe <- a@table_dataframe[new_order, ]

a@notes[[2]] <- "All results are reported at the percentile level. We used the railroad division index as our instrumental variable."
a@names[2] <- "Black/White Dissimilarity Index"
a@names[3] <- "Black/White Exposure Index"
a

# IV analysis with covariates
project <- project |>
  mutate(
    city = substr(cityname, 1, nchar(cityname) - 2),
    state = substr(cityname, nchar(cityname) - 1, nchar(cityname))
  )


southern_states <- c("wa","mi","me")

project <- project |>
  mutate(southern = ifelse(state %in% southern_states, 1, 0))




model1_cov <- ivreg(kfr_black_male_p25_1992  ~ disswb * avg_black_inc + southern  |
                      herf * avg_black_inc + southern , data = project)

summary(model1_cov)


model2_cov <- ivreg(kfr_black_male_p25_1992  ~ exposurewb * avg_black_inc + southern |
                      herf * avg_black_inc + southern , data = project)

summary(model2_cov)



m_list_2 <- list(Dissimilarity = model1_cov, Exposure = model2_cov)

a <- msummary(m_list_2,
              stars = TRUE)
a@table_dataframe[3,1]<- "Black/White Dissimilarity Index"
a@table_dataframe[5,1] <- "Average black incarceration"
a@table_dataframe[7,1] <- "States far from South (WA, ME, MI)"
a@table_dataframe[9,1] <- "Black/White Dissimilarity Index*Average black incarceration"
a@table_dataframe[11,1] <- "Black/White Exposure Index"
a@table_dataframe[13,1] <- "Black/White Exposure Index*Average black incarceration"

new_order <- c(3, 4, 5, 6, 9, 10, 11, 12, 13, 14, 7, 8, 1, 2, 15, 16,
               17, 18, 19, 20) 
a@table_dataframe <- a@table_dataframe[new_order, ]

a@notes[[2]] <- "All results are reported at the percentile level. We used the railroad division index as our instrumental variable. This result is obtained after controlling for covariates, including states far from south."
a@names[2] <- "Black/White Dissimilarity Index"
a@names[3] <- "Black/White Exposure Index"
a

# OLS estimation
ols1 <- lm(kfr_black_male_p25_1992  ~ disswb * avg_black_inc, data = project)
summary(ols1)

ols2 <- lm(kfr_black_male_p25_1992  ~ exposurewb * avg_black_inc, data = project)
summary(ols2)

m_list_ols <- list(Dissimilarity = ols1, Exposure = ols2)

a <- msummary(m_list_ols,
              stars = TRUE)
a@table_dataframe[3,1]<- "Black/White Dissimilarity Index"
a@table_dataframe[5,1] <- "Average black incarceration"
a@table_dataframe[7,1] <- "Black/White Dissimilarity Index*Average black incarceration"
a@table_dataframe[9,1] <- "Black/White Exposure Index"
a@table_dataframe[11,1] <- "Black/White Exposure Index*Average black incarceration"

new_order <- c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 13, 14,
               15, 16) 
a@table_dataframe <- a@table_dataframe[new_order, ]

a@notes[[2]] <- "All results are reported at the percentile level. This result is for OLS regression."
a@names[2] <- "Black/White Dissimilarity Index"
a@names[3] <- "Black/White Exposure Index"
a