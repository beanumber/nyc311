#' etl_load
#' @export
#' @rdname etl_extract.etl_nyc311
#' @method etl_load etl_nyc311
#' @import dplyr
#' @import etl
#' @importFrom DBI dbWriteTable
#' @importFrom lubridate year month
#' @inheritParams etl::etl_extract
#' @param years years that the issues have been created (the most recent year is the default)
#' @param months months that the issues have been created (the most recent month is the default)
#' @param ... arguments passed to \code{\link{download.file}}. Set method as "curl" for Linux system, and as default for Windows and Mac OS X systems.
#' @details This function loads NYC311 data into a local database for years and months specified.
#' @examples 
#' \dontrun{
#' calls <- etl("nyc311", dir = "~/Desktop/nyc311")
#' calls %>%
#'   etl_extract(years = 2010:2011, months = 1:3, n =100) %>%
#'   etl_transform(years = 2010:2011, months = 1:3) %>%
#'   etl_load(years = 2010:2011, months = 1:3)
#'
#' calls %>%
#'   tbl("calls") %>%
#'   glimpse()
#'   
#' calls <- calls %>%
#'   tbl("calls") %>%
#'   collect()
#' }
etl_load.etl_nyc311 <- function(obj, schema = FALSE, years = lubridate::year(Sys.Date()), 
                                months = lubridate::month(Sys.Date()), ...) {
  #check if the year is valid
  valid_months <- etl::valid_year_month(years, months, begin = "2010-01-01")
  
  #raw dir
  src_length <- nrow(valid_months)
  dir <- attr(obj, "raw_dir")
  valid_months <- mutate(valid_months, 
                         lcl = paste0(dir, "/nyc311_", valid_months$year, "_", valid_months$month, ".csv"))
  #new dir
  new_dir <- attr(obj, "load_dir")
  valid_months <- mutate_(valid_months, 
                          new_lcl = ~paste0(new_dir, "/", basename(lcl)))
  
  #table
  for (i in 1:src_length) {
    DBI::dbWriteTable(conn = obj$con, name = "calls", value = valid_months$new_lcl[i], append = TRUE, sep = "|", ...)
  }
  message("Writing NYC311 data to the database...")
  invisible(obj)
}