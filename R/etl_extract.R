#' Using NYC311 data
#' 
#' @export
#' @import dplyr
#' @import etl
#' @importFrom utils download.file
#' @inheritParams etl::etl_extract
#' @param year a single year (2010 is the default)
#' @param month a single month (1 is the default)
#' @param n number of readings (1000000 is the default)
#' @param ... arguments passed to \code{\link{download.file}}
#' 
#' @examples 
#' calls <- etl("nyc311", dir = "~/Desktop/nyc311")
#' calls %>%
#'   etl_extract(method = "curl") %>%
#'   etl_transform() %>%
#'   etl_load()
#'
#' calls %>%
#'   tbl("calls") %>%
#'   glimpse()
#'   
#' calls_2010_01 <- calls %>%
#'   tbl("calls") %>%
#'   collect()
#'   
#' calls_2010_01_cleaned <- calls_2010_01 %>%
#'   mutate(closed_date = as.Date(closed_date, tz = "EST")) %>%
#'   mutate(created_date = as.Date(created_date, tz = "EST")) %>%
#'   mutate(resolution_updated_date = as.Date(resolution_action_updated_date, tz = "EST")) 
#'
#'
etl_extract.etl_nyc311 <- function(obj, year = 2010 , month = 1 , n = 1000000, ...) {
  #check if the month is valid
  new_month <- month + 1
  ifelse(lubridate::is.Date(as.Date(paste0(year, "-", month, "-01"))),
         begin <- as.Date( paste0(year, "-", month, "-01")),
         begin <- Sys.Date() - 2)
  
  ifelse(lubridate::is.Date(as.Date(paste0(year, "-", new_month, "-01"))),
         end <- as.Date( paste0(year, "-", new_month, "-01")) -1,
         end <- Sys.Date() - 1)
  
  #url
  base_url <- "https://data.cityofnewyork.us/resource/fhrw-4uyv.csv"
  src <- paste0(base_url, 
                "?$where=created_date%20between%20'", begin,
                "'%20and%20'", end, "'&$limit=", format(n, scientific = FALSE))
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/nyc311_", year, "_", month, ".csv")
  utils::download.file(src, lcl, ...)
  invisible(obj)
}

#' @export
#' @importFrom readr write_delim read_csv
#' @rdname etl_extract.etl_nyc311
#' @importFrom lubridate ymd_hms
etl_transform.etl_nyc311 <- function(obj, year = 2010 , month = 1 , n = 1000000, ...) {
  #raw dir
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/nyc311_", year, "_", month, ".csv")
  
  #new dir
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/", basename(lcl))
  datafile <- readr::read_csv(lcl)
  readr::write_delim(datafile, path = new_lcl, delim = "|")
  invisible(obj)
}

#' @export
#' @importFrom DBI dbWriteTable
#' @rdname etl_extract.etl_nyc311
#etl load
etl_load.etl_nyc311 <- function(obj, schema = FALSE, year = 2010 , month = 1 , n = 1000000, ...) {
  #new dir
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/nyc311_", year, "_", month, ".csv")
  
  #table
  DBI::dbWriteTable(conn = obj$con, name = "calls", value = new_lcl, append = TRUE, sep = "|", ...)
  message("Writing NYC311 data to the database...")
  invisible(obj)
}





