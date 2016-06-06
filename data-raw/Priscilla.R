devtools::install_github("beanumber/etl")
library(etl)

#obj
obj<-calls

#example
begin <- "2010-01-01"
end <- "2010-01-01"

#rvest

library(readr)
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
}




# 05/30/16
y <- c("1,200","20,000","100","12,111")
gsub(",", "", y)


guess <- read.csv("mtcars.csv", stringsAsFactors=FALSE, nrows=1000)
create <- sprintf("CREATE TABLE mtcars ( %s )", 
                  paste0(sprintf('"%s" %s', colnames(guess), 
                                 sapply(guess, dbDataType, dbObj=mdb)), collapse=","))

#api edpoint
#https://data.cityofnewyork.us/resource/fhrw-4uyv.json



https://data.cityofnewyork.us/resource/fhrw-4uyv.csv?created_date<2011-01-02

url <- https://data.cityofnewyork.us/resource/fhrw-4uyv.csv?$where=created_date%20between%20'2015-01-10T12:00:00'%20and%20'2015-01-10T14:00:00'

url <- "https://data.cityofchicago.org/resource/6zsd-86xi.json?$where=date%20between%20'2015-01-10T12:00:00'%20and%20'2015-01-10T14:00:00'"
utils::download.file(url, lcl, method = "auto")


# Socrata
library(RSocrata)
ls.socrata("https://data.cityofnewyork.us/resource/fhrw-4uyv")
nyc311data <- read.socrata("https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$where=created_date%20between%20'2010-01-01'%20and%20'2010-01-01'")


earthquakesDataFrame <- read.socrata("http://soda.demo.socrata.com/resource/4334-bgaj.csv")
nrow(earthquakesDataFrame) # 1007 (two "pages")
class(earthquakesDataFrame$Datetime[1]) # P




#MySQL Connection
library(dplyr)
library(etl)
db <- src_mysql(dbname = "airlines", host = "localhost",
                user = "WencongLi", password = "P320718")
airlines <- etl("airlines", db, dir = "~/Desktop/airlines")
summary(airlines)
str(airlines)
res <- tbl(db, sql("SELECT faa, name FROM airports"))
res

db1 <- src_mysql(dbname = "macleish", host = "localhost",
                 user = "WencongLi", password = "P320718")
macleish <- etl("macleish", db1, dir = "~/Desktop/macleish")

macleish %>%
  etl_create()
macleish %>%
  tbl("orchard") %>%
  collect() %>%
  head()

db <- src_mysql(dbname = "airlines", host = "localhost",
                user = "WencongLi", password = "P320718")
macleish <- etl("macleish", db)


macleish %>%
  etl_extract() %>%
  etl_transform() %>%
  etl_load()

whately <- macleish %>%
  tbl("whately")

library(DBI)
con <- dbConnect(MySQL(), dbname = "calls", host = "localhost",
                 user = "WencongLi", password = "P320718")

close_date <- dbGetQuery(con, "SELECT closed_date
                         FROM calls")
head(close_date, 10)
class(close_date)


#
library(babynames)
babynames %>%
  filter(year > 1975) %>%
  write.csv(file = "babynames.csv", row.names = FALSE)
births %>%
  write.csv(file = "births.csv", row.names = FALSE)
list.files(".", pattern = ".csv")
glimpse(babynames)


glimpse(births)


library(RMySQL)
db <- src_mysql(dbname = "babynamedata", host = "localhost", user = "WencongLi",
                password = "P320718")
babynames <- tbl(db, "births")
babynames %>% filter(name == "Benjamin")



