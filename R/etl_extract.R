#' Using NYC311 data
#' 
#' @export
#' @import dplyr
#' @import etl
#' @importFrom utils download.file
#' @inheritParams etl::etl_extract
#' @param begin begin date
#' @param end end date
#' @param n number of readings (has to be less than or equal to one million)
#' 
#' @examples 
#' calls <- etl("nyc311", dir = "~/Desktop/nyc311")
#' calls %>%
#'   etl_extract(n = 10) %>%
#'   etl_transform() %>%
#'   etl_load()
#'
#' calls %>%
#'   tbl("calls") %>%
#'   glimpse()
#'
#'
etl_extract.etl_nyc311 <- function(obj, begin = Sys.Date() - 1, end = Sys.Date(), n = 0:1000000, ...) {
  #start and end date
  begin_char <- clean_date(begin)
  end_char <- clean_date(end)
  
  #url
  base_url <- "https://data.cityofnewyork.us/resource/fhrw-4uyv.csv"
  src <- paste0(base_url, 
                "?$where=created_date%20between%20", begin_char,
                "%20and%20", end_char, "&$limit=", n)
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/", begin, "-", end, "nyc311data.csv")
  utils::download.file(src, lcl, method = "auto")
  invisible(obj)
}

#' @export
#' @importFrom readr write_delim read_csv
#' @rdname etl_extract.etl_nyc311
etl_transform.etl_nyc311 <- function(obj, begin = Sys.Date() - 1, end = Sys.Date(), ...) {
  #start and end date
  begin_char <- clean_date(begin)
  end_char <- clean_date(end)
  
  #raw dir
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/", begin, "-", end, "nyc311data.csv")
  
  #load dir
  #copy filr from raw to load
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/", begin, "_", end, "_nyc311.csv")
  datafile <- readr::read_csv(lcl)
  readr::write_delim(datafile, path = new_lcl, delim = "|")
  invisible(obj)
}

#' @export
#' @importFrom DBI dbWriteTable
#' @rdname etl_extract.etl_nyc311
#etl load
etl_load.etl_nyc311 <- function(obj, schema = FALSE, begin = Sys.Date() - 1, end = Sys.Date(), ...) {
  message("Writing NYC311 data to the database...")
  
  #start and end date
  begin_char <- clean_date(begin)
  end_char <- clean_date(end)
  
  #dir
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/", begin, "_", end, "_nyc311.csv")
  
  #table
  DBI::dbWriteTable(conn = obj$con, name = "calls", value = new_lcl, append = TRUE, sep = "|", ...)
  invisible(obj)
}




