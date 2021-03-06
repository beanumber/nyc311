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
#' @param num_calls number of readings (1000000 is the default)
#' @param ... arguments passed to \code{\link{download.file}}. Set method as "curl" for Linux system, and as default for Windows and Mac OS X systems.
#' @details This function downloads NYC311 data from NYC311 OPEN DATA website for years and months specified.
etl_extract.etl_nyc311 <- function(obj, years = lubridate::year(Sys.Date()), 
                                   months = lubridate::month(Sys.Date()), 
                                   num_calls = 1000000, ...) {
  message("Extracting raw data...")
  
  #check if the year is valid
  valid_months <- etl::valid_year_month(years, months, begin = "2010-01-01")

  #url
  base_url <- "https://data.cityofnewyork.us/resource/fhrw-4uyv.csv"
  valid_months <- mutate_(valid_months, src = ~paste0(base_url, 
                  "?$where=created_date%20between%20'", month_begin,
                  "'%20and%20'", month_end, "'&$limit=", format(num_calls, scientific = FALSE)))
  dir <- attr(obj, "raw_dir")
  valid_months <- mutate(valid_months, lcl = paste0(dir, "/nyc311_", valid_months$year, "_", valid_months$month, ".csv"))
  
  smart_download2 <- function(obj, src, new_filenames = basename(src), type = utils::download.file,  ...) {
    if (length(src) != length(new_filenames)) {
      stop("src and new_filenames must be of the same length")
    }
    lcl <- file.path(attr(obj, "raw_dir"), new_filenames)
    missing <- !file.exists(lcl)
    mapply(type, src[missing], lcl[missing], ... = ...)
  }
  
  #first try
  first_try<-tryCatch(
    smart_download2(obj, src = valid_months$src, new_filenames = basename(valid_months$lcl),
                   method = "curl", quiet = FALSE),
    error = function(e){warning(e)},finally = 'method = "curl" fails')
  
  ifelse(first_try[[1]] == 0, print("Download succeeded."), 
         tryCatch(smart_download2(obj, src = valid_months$src, new_filenames = basename(valid_months$lcl), 
                                 method = "auto", quiet = FALSE),
           error = function(e){warning(e)},finally = 'method = "auto" fails'))
  invisible(obj)
}
