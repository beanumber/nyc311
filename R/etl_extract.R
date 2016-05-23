#' using 311 data
#' 
#' @export
#' @importFrom RSocrata read.socrata
#' 
#' @examples 
#' 
#' calls <- etl("nyc311")
#' calls %>%
#'   etl_extract() %>%
#'   etl_transform()
#'
etl_extract.etl_nyc311 <- function(obj, year = 2015, month = 03, day =18, ...) {
  #this_year <- as.numeric(format(Sys.Date(), '%Y'))
  #years <- intersect(1987:this_year, years)
  #months <- intersect(01:12, months)
  #days <- intersect(01:30, days)
  
  base_url <- "https://data.cityofnewyork.us/resource/"
  date = paste0( "'", year, "-", month, "-", day,  "'")
  src <- paste0(base_url, "fhrw-4uyv.csv?$where=date_trunc_ymd(created_date)=", date)
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/", basename(src))
  download.file(src, lcl, method = 'curl')
  invisible(obj)
}

#' @export
#' @rdname etl_extract.etl_nyc311
etl_transform.etl_nyc311 <- function(obj,  year = 2015, month = 03, day =18, ...) {
  dir <- attr(obj, "raw_dir")
  new_dir <- attr(obj, "load_dir")
  file.copy(dir, new_dir)
  invisible(obj)
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


