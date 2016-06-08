clean_date_begin <- function(x) {
  today_date <- Sys.Date()
  origin <- as.Date("2010-01-01")
  the_date <- as.Date(x)
  cleaned_date <- paste0( "'", as.character(the_date),  "'")
  default <- paste0( "'", as.character(today_date-2),  "'")
  ifelse(origin <= the_date & the_date <= today_date,cleaned_date,default)
}

clean_date_end <- function(x) {
  today_date <- Sys.Date()
  origin <- as.Date("2010-01-01")
  the_date <- as.Date(x)
  cleaned_date <- paste0( "'", as.character(the_date),  "'")
  default <- paste0( "'", as.character(today_date-1),  "'")
  ifelse(origin <= the_date & the_date <= today_date,cleaned_date,default)
}