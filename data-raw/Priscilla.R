

#example
year<-2015
month<-03
day<-18

obj<-calls
require(rvest)
nyc311<- read_html("https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9")
class(nyc311)
nyc311_context <- nyc311%>%
  html_nodes(".blist-td blist-t1-c217215390 blist-td-date") %>%
  html_text()


#endpoint
#https://data.cityofnewyork.us/OData.svc/erm2-nwe9

#?$where=date_trunc_ymd(created_date)='2015-3-18'

#https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$where=date_trunc_ymd(created_date)='2015-3-18'


#
#https://data.ny.gov/api/views/fhrw-4uyv?$where=date_trunc_ymd(created_date)='2015-3-18'

# zip and unzip 
#test <-read.csv(url(src))
#test_zip<-export(test, "test.csv.zip",format = "csv")
#unzip(test_zip, exdir = "~/Desktop/")

