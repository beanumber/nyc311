#' using 311 data
#' 
#' @export
#' @import dplyr
#' @import etl
#' @importFrom RSocrata read.socrata
#' @importFrom utils download.file 
#' @param year a numeric variable that inidicates the year
#' @param month a numeric variable that inidicates the month
#' @param day a numeric variable that inidicates the day
#' 
#' @examples 
#' 
#' calls <- etl("nyc311", dir = "~/Desktop/nyc311")
#' calls %>%
#'   etl_extract() %>%
#'   etl_transform() %>%
#'   etl_load()
#' 
etl_extract.etl_nyc311 <- function(obj, year = 1987:this_year, month = 01:12, day =01:30, ...) {
  this_year <- as.numeric(format(Sys.Date(), '%Y'))
  years <- intersect(1987:this_year, year)
  months <- intersect(01:12, month)
  days <- intersect(01:30, day)
  
  base_url <- "https://data.cityofnewyork.us/resource/"
  date = paste0( "'", year, "-", month, "-", day,  "'")
  src <- paste0(base_url, "fhrw-4uyv.csv?$where=date_trunc_ymd(created_date)=", date)
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/","nyc311data.csv")
  utils::download.file(src, lcl, method = "libcurl")
  invisible(obj)
}

#' @export
#' @rdname etl_extract.etl_nyc311
etl_transform.etl_nyc311 <- function(obj,  year = 2015, month = 03, day =18, ...) {
  
  base_url <- "https://data.cityofnewyork.us/resource/"
  date = paste0( "'", year, "-", month, "-", day,  "'")
  src <- paste0(base_url, "fhrw-4uyv.csv?$where=date_trunc_ymd(created_date)=", date)
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/", "nyc311data.csv")
  nyc311dataframe<-read.csv(lcl)
  
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/", "nyc311data.csv")
  write.csv(nyc311dataframe, file = new_lcl)
  invisible(obj)
}

#etl load
etl_load.etl_nyc311 <- function(obj,  year = 2015, month = 03, day =18, ...) {
  message("Writing NYC311 data to the database...")
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/", "nyc311data.csv")
  date = paste0( "'", year, "-", month, "-", day,  "'")
  tablename <- paste0("nyc311", date)
  DBI::dbWriteTable(conn = obj$con, name = tablename, value = new_lcl, append = TRUE, ...)
  invisible(obj)
}




