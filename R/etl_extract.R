#' Using NYC311 data
#' 
#' @export
#' @import dplyr
#' @import etl
#' @import lubridate
#' @importFrom utils download.file 
#' @param begin begin date
#' @param end end date
#' 
#' @examples 
#' calls <- etl("nyc311", dir = "~/Desktop/nyc311")
#' calls %>%
#'   etl_extract() %>%
#'   etl_transform() %>%
#'   etl_load()
#'
etl_extract.etl_nyc311 <- function(obj, begin = "2010-01-01":today_date, end = "2010-01-01":today_date, ...) {
  today_date <- Sys.Date()
  origin <- as.Date("2010-01-01")
  begin_date <- as.Date(begin)
  end_date <- as.Date(end)
  begin_num <- intersect(origin:today_date, begin_date)
  end_num <- intersect(origin:today_date, end_date)
  begin <- as.Date(begin_num, origin = "1970-01-01")
  end <- as.Date(end_num, origin = "1970-01-01")
  begin_char <- paste0( "'", as.character(begin),  "'")
  end_char <- paste0( "'", as.character(end),  "'")
  
  #url
  base_url <- "https://data.cityofnewyork.us/resource/"
  src <- paste0(base_url, 
                "fhrw-4uyv.csv?$where=date_trunc_ymd(created_date)<=", end_char)
                #,"&$where=date_trunc_ymd(created_date)>", begin_char)
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/","nyc311data.csv")
  utils::download.file(src, lcl, method = "auto")
  invisible(obj)
}

#' @export
#' @rdname etl_extract.etl_nyc311
etl_transform.etl_nyc311 <- function(obj, year = 1987:this_year, month = 01:12, day =01:30, ...) {
  this_year <- as.numeric(format(Sys.Date(), '%Y'))
  years <- intersect(1987:this_year, year)
  months <- intersect(01:12, month)
  days <- intersect(01:30, day)
  
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





