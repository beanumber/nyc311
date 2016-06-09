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
#' @param ... arguments passed to \code{\link{download.file}}
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
etl_extract.etl_nyc311 <- function(obj, begin = Sys.Date() - 2, end = Sys.Date() - 1, n = 1000000, ...) {
  #start and end date
  if (!lubridate::is.Date(as.Date(begin))) {
    begin <- Sys.Date() - 2
  }
  if (!lubridate::is.Date(as.Date(end))) {
    end <- Sys.Date() - 1
  }
  #url
  base_url <- "https://data.cityofnewyork.us/resource/fhrw-4uyv.csv"
  src <- paste0(base_url, 
                "?$where=created_date%20between%20'", begin,
                "'%20and%20'", end, "'&$limit=", format(n, scientific = FALSE))
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/nyc311_", begin, "_", end, ".csv")
  utils::download.file(src, lcl, ...)
  invisible(obj)
}

#' @export
#' @importFrom readr write_delim read_csv
#' @rdname etl_extract.etl_nyc311
#' @importFrom lubridate ymd_hms
etl_transform.etl_nyc311 <- function(obj, begin = Sys.Date() - 2, end = Sys.Date() - 1, ...) {
  #start and end date
  if (!lubridate::is.Date(as.Date(begin))) {
    begin <- Sys.Date() - 2
  }
  if (!lubridate::is.Date(as.Date(end))) {
    end <- Sys.Date() - 1
  }
  #raw dir
  dir <- attr(obj, "raw_dir")
  lcl <- paste0(dir, "/nyc311_", begin, "_", end, ".csv")
  
  #load dir
  #copy filr from raw to load
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
etl_load.etl_nyc311 <- function(obj, schema = FALSE, begin = Sys.Date() - 2, end = Sys.Date()-1, ...) {
  message("Writing NYC311 data to the database...")
  
  #start and end date
  if (!lubridate::is.Date(as.Date(begin))) {
    begin <- Sys.Date() - 2
  }
  if (!lubridate::is.Date(as.Date(end))) {
    end <- Sys.Date() - 1
  }
  #dir
  new_dir <- attr(obj, "load_dir")
  new_lcl <- paste0(new_dir, "/nyc311_", begin, "_", end, ".csv")
  
  #table
  DBI::dbWriteTable(conn = obj$con, name = "calls", value = new_lcl, append = TRUE, sep = "|", ...)
  invisible(obj)
}





