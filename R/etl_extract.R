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
  #start and end date
  today_date <- Sys.Date()
  origin <- as.Date("2010-01-01")
  begin_date <- as.Date(begin)
  end_date <- as.Date(end)
  begin_num <- intersect(origin:today_date, begin_date)
  end_num <- intersect(origin:today_date, end_date)
  begin_d <- as.Date(begin_num, origin = "1970-01-01")
  end_d <- as.Date(end_num, origin = "1970-01-01")
  begin_char <- paste0( "'", as.character(begin_d),  "'")
  end_char <- paste0( "'", as.character(end_d),  "'")
  
  #url
  base_url <- "https://data.cityofnewyork.us/resource/fhrw-4uyv.csv"
  src <- paste0(base_url, 
                "?$where=created_date%20between%20", begin_char,
                "%20and%20", end_char)
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/", begin, "-", end, "nyc311data.csv")
  utils::download.file(src, lcl, method = "auto")
  invisible(obj)
}

#' @export
#' @rdname etl_extract.etl_nyc311
etl_transform.etl_nyc311 <- function(obj, begin = "2010-01-01":today_date, end = "2010-01-01":today_date, ...) {
  #start and end date
  today_date <- Sys.Date()
  origin <- as.Date("2010-01-01")
  begin_date <- as.Date(begin)
  end_date <- as.Date(end)
  begin_num <- intersect(origin:today_date, begin_date)
  end_num <- intersect(origin:today_date, end_date)
  begin_d <- as.Date(begin_num, origin = "1970-01-01")
  end_d <- as.Date(end_num, origin = "1970-01-01")
  begin_char <- paste0( "'", as.character(begin_d),  "'")
  end_char <- paste0( "'", as.character(end_d),  "'")
  
  #url
  base_url <- "https://data.cityofnewyork.us/resource/fhrw-4uyv.csv"
  src <- paste0(base_url, 
                "?$where=created_date%20between%20", begin_char,
                "%20and%20", end_char)
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/", begin, "-", end, "nyc311data.csv")
  
  #copy filr from raw to load
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/", begin, "-", end, "nyc311data.csv")
  file.copy(lcl, new_lcl)
  #resolution_description column has comma
  
  
  #gsub(",", "", new_lcl)
  invisible(obj)
}

#etl load
etl_load.etl_nyc311 <- function(obj, begin = "2010-01-01":today_date, end = "2010-01-01":today_date, ...) {
  message("Writing NYC311 data to the database...")
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/", begin, "-", end, "nyc311data.csv")
  date = paste0( "'", year, "-", month, "-", day,  "'")
  tablename <- paste0("nyc311", date)
  DBI::dbWriteTable(conn = obj$con, name = tablename, value = new_lcl, append = TRUE, ...)
  invisible(obj)
}





