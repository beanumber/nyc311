
#etl extract
etl_extract.etl_nyc311 <- function(obj, year = 2015, month = 03, day =18, ...) {
  years <- intersect(1987:2015, years)
  months <- intersect(01:12, months)
  days <- intersect(01:30, days)
  
  base_url <- "https://data.cityofnewyork.us/resource/"
  date = paste0( "'", year, "-", month, "-", day,  "'")
  src <- paste0(base_url, "fhrw-4uyv.csv?$where=date_trunc_ymd(created_date)=", date)
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/", basename(src))
  # I don't know how to download this data. 
  # download.file does not work for this data set
  #? download.file(src, lcl, method = 'curl')
}

#etl transorm
etl_transform.etl_nyc311 <- function(obj,  year = 2015, month = 03, day =18, ...) {
  dir <- attr(obj, "raw_dir")
  base_url <- "https://data.cityofnewyork.us/resource/"
  src <- paste0(base_url, "fhrw-4uyv.csv?$where=date_trunc_ymd(created_date)=", date)
  new_dir <- attr(obj, "load_dir")
  read.csv(url(src))
  #I donno how to specify a dir for this csv file
}

#etl load
etl_load.etl_nyc311 <- function(obj,  year = 2015, month = 03, day =18, ...) {
  dir <- attr(obj, "raw_dir")
  base_url <- "https://data.cityofnewyork.us/resource/"
  src <- paste0(base_url, "fhrw-4uyv.csv?$where=date_trunc_ymd(created_date)=", date)
  message("Writing NYC311 data to the database...")
  date = paste0( "'", year, "-", month, "-", day,  "'")
  tablename <- paste0("NYC311",date)
  DBI::dbWriteTable(obj$con, tablename, src, append = TRUE, ...)
}


