library(etl)
library(dplyr)
calls <- etl("nyc311", dir = "~/Desktop/nyc311")
calls <- calls %>%
  etl_extract(begin = "2017-01-01", end= "2017-01-01",n = 10) %>%
  etl_transform(begin = "2017-01-01", end= "2017-01-01") %>%
  etl_load()

calls <- calls %>%
  tbl("calls") %>%
  glimpse() 
