# PUBPOL6090 - Divided Spaces, Unequal Outcomes: The Role of Segregation in Black Economic Mobility


## General Information
Authors: Edoardo Di Vicenzo (Sociology, ed554@cornell.edu), Chae Kim (Sociology, ck763@cornell.edu), Jiwoo Kim (Psychology, jk2759@cornell.edu), Hazel Lee (Regional Science, yl3276@cornell.edu)

Date of Data Collection: 2024-11-25 

Location of Data Collection: Ithaca, New York, USA

Project Contacts (as of December 2024): Hazel Lee, yl3276@cornell.edu

## Content
The content in this project folder contain data and results for the final project for PUBPOL 6090, Fall 2024. 

All folders are organized using the following approach:
'PUBPOL6090_(Data Set)'

## Sharing/Access Information
### Links to Datasets
Economic Mobility - [Opportunity Atlas](https://opportunityinsights.org/data/?geographic_level=102&topic=0&paper_id=0#resource-listing)

Incarceration Rate - [Vera Institue of Justice](https://github.com/vera-institute/incarceration-trends/blob/main/incarceration_trends.xlsx)

Railroad Index - [Ananat (2011) ICPSR](https://www.openicpsr.org/openicpsr/project/113786/version/V1/view?path=/openicpsr/113786/fcr:versions/V1/LICENSE.txt&type=file)

Black and White Population - [NHGIS](https://data2.nhgis.org/main) 

ACS Decennial Survey - [ACS](https://data2.nhgis.org/main)

## Methodological Information 
### Methods for Processing the Data
Economic Mobility variable was downloaded directly from the Opportunity Atlas for the cohort group of 1992. Incarceration rates are reported for counties on a yearly basis for Black males. The county level data was averaged out for the years between 1992-2009. Railroad Index was downloaded from Ananat (2011) ICPSR. The railroad index was at the city level so we matched the counties to each city before merging the railroad index to our county-level master data set. ACS variables were used for both segregation indices and covariates. Segregation indices such as the dissmilarity index and exposure index was caclulated with the average Black and White population of 1990 and 2000. We use county level data and and compare it to the racial distribution of a larger geographic area, the state-level data which as also downloaded from NHGIS with the same years. Covariates such as education, poverty, and employment rate were from the 2000 decennial census survey, which correlates with the childhood years of the 1992 cohort.

### Contriubtors to sample collection, processing and analysis
All group members were involved in the process.

## Data Specific Information 
### Data Folder
PUBPOL6090_ACS2000CENSUS - dta file contains 3141 counties representing all counties in the USA

PUBPOL6090_Ananat2011 - dta file file contains 121 cities. These cities are matched with counties and fips codes and used as the final number of observations in the county level

PUBPOL6090_IncarcerationTrends - xls file contains incarceration rates for counties in the year 1970-2018. We use the black male incarceration rates between 1992-2009, which is the year that our cohort were 0-18 years old.

PUBPOL6090_OpportunityAtlasCounty - dta file file contains 1246 observations for counties in the USA. The variable 'kfr_black_male_p25_1992' is used as our dependent variable. 

PUBPOL6090 - (FINAL DATA SET) - dta file contains all variables and observations to produce our final results.

### Analysis Folder
PUBPOL6090_(DO FILE) - Stata Do files contain all the data generating process and cleaning process for the preliminary process.

PUBPOL6090_(R FILE) - R file contains the codes and results to merge decennial census data to the master data and for the analysis parts such as running regressions and creating tables. 
