# NYC311 (Phone Call Tracking System Data)

[![Travis-CI Build Status](https://travis-ci.org/beanumber/nyc311.svg?branch=master)](https://travis-ci.org/beanumber/nyc311)

`nyc311` is a R package based on ETL framework to interface with NYC311 Phone call tracking system data. This package contains information collected from [NYC Open Data Portal](https://data.cityofnewyork.us/resource/fhrw-4uyv), and it allows users to download multiple years of phone call data to a local SQL database. 

NYC Open Data Portal updates NYC311 dataset everyday, so users can get access to phone call information from 2010-01-10 to yesterday. This package uses the [ETL](http://github.com/beanumber/etl) framework.

## To install the package
```{r, eval=FALSE, message=FALSE}
install.packages("devtools")
devtools::install_github("beanumber/nyc311")
```

## To load the package
This command loads both `etl` and `dplyr`.
```{r, message=TRUE}
library(nyc311)
```

## Create an `etl` object:
```{r}
calls <- etl("nyc311")
summary(calls)
```

## Populate the database:
```{r, message=FALSE}
calls %>%
  etl_extract(years = 2010:2011, months = 1:2, num_calls = 100) %>%
  etl_transform(years = 2010:2011, months = 1:2) %>%
  etl_load(years = 2010:2011, months = 1:2)
```

Now you can pull the data that you are interested in into your R Environment.
```{r, message=FALSE}
my_calls <- calls %>%
  tbl("calls") %>%
  collect()
```

And take a look at it.
```{r, message=FALSE}
glimpse(my_calls)
```

Please read [the vignette](https://github.com/beanumber/nyc311/blob/master/vignettes/my-vignette.Rmd) for more detailed examples.