#' etl_transform
#' @export
#' @rdname etl_extract.etl_nyc311
#' @method etl_transform etl_nyc311
#' @import dplyr
#' @import etl
#' @importFrom readr write_delim read_csv
#' @importFrom lubridate year month
#' @inheritParams etl::etl_extract
#' @details This function transforms NYC311 data for years and months specified.
#' 
etl_transform.etl_nyc311 <- function(obj, years = lubridate::year(Sys.Date()), 
                                     months = lubridate::month(Sys.Date()), ...) {
  #check if the year is valid
  valid_months <- etl::valid_year_month(years, months, begin = "2010-01-01")
  
  #raw dir
  dir <- attr(obj, "raw_dir")
  src_length <- nrow(valid_months)
  dir <- attr(obj, "raw_dir")
  valid_months <- mutate(valid_months, lcl = paste0(dir, "/nyc311_", valid_months$year, "_", valid_months$month, ".csv"))
  
  #new dir
  new_dir <- attr(obj, "load_dir")
  valid_months <- mutate_(valid_months, new_lcl = ~paste0(new_dir, "/", basename(lcl)))
  for (i in 1:src_length) {
    datafile <- readr::read_csv(valid_months$lcl[i])
    readr::write_delim(datafile, path = valid_months$new_lcl[i], delim = "|", na = "")
  }
  invisible(obj)
}
