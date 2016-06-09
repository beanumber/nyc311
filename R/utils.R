
clean_date <- function(x, begin_end) {
  today_date <- Sys.Date()
  origin <- as.Date("2010-01-01")
  the_date <- as.Date(x)
  cleaned_date <- paste0( "'", as.character(the_date),  "'")
  default_begin <- paste0( "'", as.character(today_date-2),  "'")
  default_end <- paste0( "'", as.character(today_date-1),  "'")
  ifelse(origin <= the_date & the_date <= today_date,
         cleaned_date,
         ifelse(begin_end,default_begin,default_end)
         )
}