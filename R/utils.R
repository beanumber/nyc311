
clean_date <- function(x) {
  # add some integrity checks to make sure this *always* returns a valid date
  the_date <- as.Date(x)
  return(paste0( "'", as.character(the_date),  "'"))
}
