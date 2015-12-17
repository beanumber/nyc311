

#' @export
#' @importFrom RSocrata read.socrata
#' 
#' @examples 
#' 
#' calls <- etl("nyc311")
#' calls %>%
#'   etl_extract()
#' 
etl_extract.etl_nyc311 <- function(obj, ...) {
  ds_list <- ls.socrata("https://data.cityofnewyork.us/")
  df <- read.socrata("https://data.cityofnewyork.us/resource/fhrw-4uyv.csv?$where=date_trunc_ymd(created_date)='2015-03-18'")
}