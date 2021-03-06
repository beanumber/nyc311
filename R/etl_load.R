#' etl_load
#' @export
#' @rdname etl_extract.etl_nyc311
#' @method etl_load etl_nyc311
#' @import dplyr
#' @import etl
#' @importFrom DBI dbWriteTable
#' @importFrom lubridate year month
#' @inheritParams etl::etl_extract
#' @details This function loads NYC311 data into a local database for years and months specified.
#' @examples 
#' \dontrun{
#' calls <- etl("nyc311")
#' calls %>%
#'  etl_extract(years = 2010:2011, months = 1:3, num_calls = 100)
#'  
#' calls %>%
#'   etl_init() %>%
#'   etl_update(years = 2010:2011, months = 1:3, num_calls = 100)
#'
#' calls %>%
#'   tbl("calls") %>%
#'   glimpse()
#'   
#' calls_df <- calls %>%
#'   tbl("calls") %>%
#'   collect()
#' }
etl_load.etl_nyc311 <- function(obj, years = lubridate::year(Sys.Date()), 
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

  write_data <- function(..., num_calls) {
    lapply(valid_months$new_lcl, FUN = DBI::dbWriteTable, conn = obj$con, 
           name = "calls", append = TRUE, sep = "|", ... = ...)
  }
  write_data(...)
  
  #table
  message("Writing NYC311 data to the database...")
  invisible(obj)
}
