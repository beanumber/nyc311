#' etl_extract
#' @export
#' @rdname etl_extract.etl_nyc311
#' @method etl_extract etl_nyc311
#' @import dplyr
#' @import etl
#' @importFrom utils download.file
#' @importFrom lubridate year month
#' @inheritParams etl::etl_extract
#' @param years years that the issues have been created (the most recent year is the default)
#' @param months months that the issues have been created (the most recent month is the default)
#' @param n number of readings (1000000 is the default)
#' @param ... arguments passed to \code{\link{download.file}}. Set method as "curl" for Linux system, and as default for Windows and Mac OS X systems.
#' @details This function downloads NYC311 data from NYC311 OPEN DATA website for years and months specified.
#' 
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
etl_extract.etl_nyc311 <- function(obj, years = lubridate::year(Sys.Date()), 
                                   months = lubridate::month(Sys.Date()), 
                                   n = 1000000, ...) {
  #check if the year is valid
  valid_months <- etl::valid_year_month(years, months, begin = "2010-01-01")

  #url
  base_url <- "https://data.cityofnewyork.us/resource/fhrw-4uyv.csv"
  valid_months <- mutate_(valid_months, src = ~paste0(base_url, 
                  "?$where=created_date%20between%20'", month_begin,
                  "'%20and%20'", month_end, "'&$limit=", format(n, scientific = FALSE)))
  src_length <- nrow(valid_months)
  dir <- attr(obj, "raw_dir")
  valid_months <- mutate(valid_months, lcl = paste0(dir, "/nyc311_", valid_months$year, "_", valid_months$month, ".csv"))
  
  #first try
  first_try<-tryCatch(for (i in 1:src_length) {
    utils::download.file(valid_months$src[i], valid_months$lcl[i], 
                         method = "curl")},
           error = function(e){warning(e)},
           finally = 'method = "curl" fails')
  
  ifelse(class(first_try) == "NULL", print("Download succeeded."), 
         tryCatch(for (i in 1:src_length) {
           utils::download.file(valid_months$src[i], valid_months$lcl[i])},
           error = function(e){warning(e)},finally = 'method = "auto" fails'))
  invisible(obj)
}
