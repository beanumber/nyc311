
#obj
obj<-calls

#example
begin <- "2010-01-01"
end <- "2010-01-01"

#rvest
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


#
n = 100000 # experiment with this number
f = file(csv) 
con = open(f) # open a connection to the file
data <-read.csv(f,nrows=n,header=TRUE)
var.names = names(data)    

#setting up sqlite
con_data = dbConnect(SQLite(), dbname="yoursqlitefile")

while(nrow(data) == n) { # if not reached the end of line
  dbWriteTable(con_data, data, name="data",append=TRUE )) #write to sqlite 
data <-read.csv(f,nrows=n,header=FALSE))
names(data) <- var.names      
} 
close(f)
if (nrow(data) != 0 ) {      
  dbWriteTable(con_data, data, name="data",append=TRUE ))

