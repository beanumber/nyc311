note1
#--------------------------------------------------------------------------------
devtools::install_github("beanumber/etl")
library(etl)

#--------------------------------------------------------------------------------
#obj
obj<-calls
#example
begin <- "2010-01-01"
end <- "2010-01-01"

#--------------------------------------------------------------------------------
#rvest
library(readr)
require(rvest)
nyc311<- read_html("https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9")
class(nyc311)
nyc311_context <- nyc311%>%
  html_nodes(".blist-td blist-t1-c217215390 blist-td-date") %>%
  html_text()

#--------------------------------------------------------------------------------
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

#--------------------------------------------------------------------------------
#
n = 100000 # experiment with this number
f = file(csv) 
con = open(f) # open a connection to the file
data <-read.csv(f,nrows=n,header=TRUE)
var.names = names(data)    

#--------------------------------------------------------------------------------
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

#--------------------------------------------------------------------------------
# 05/30/16
y <- c("1,200","20,000","100","12,111")
gsub(",", "", y)


guess <- read.csv("mtcars.csv", stringsAsFactors=FALSE, nrows=1000)
create <- sprintf("CREATE TABLE mtcars ( %s )", 
                  paste0(sprintf('"%s" %s', colnames(guess), 
                                 sapply(guess, dbDataType, dbObj=mdb)), collapse=","))

#--------------------------------------------------------------------------------
#api edpoint
#https://data.cityofnewyork.us/resource/fhrw-4uyv.json
https://data.cityofnewyork.us/resource/fhrw-4uyv.csv?created_date<2011-01-02

url <- https://data.cityofnewyork.us/resource/fhrw-4uyv.csv?$where=created_date%20between%20'2015-01-10T12:00:00'%20and%20'2015-01-10T14:00:00'

url <- "https://data.cityofchicago.org/resource/6zsd-86xi.json?$where=date%20between%20'2015-01-10T12:00:00'%20and%20'2015-01-10T14:00:00'"
utils::download.file(url, lcl, method = "auto")

#--------------------------------------------------------------------------------
# Socrata
library(RSocrata)
ls.socrata("https://data.cityofnewyork.us/resource/fhrw-4uyv")
nyc311data <- read.socrata("https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$where=created_date%20between%20'2010-01-01'%20and%20'2010-01-01'")


earthquakesDataFrame <- read.socrata("http://soda.demo.socrata.com/resource/4334-bgaj.csv")
nrow(earthquakesDataFrame) # 1007 (two "pages")
class(earthquakesDataFrame$Datetime[1]) # P

#--------------------------------------------------------------------------------
#transform data type example
calls %>%
  #'  mutate(closed_date = as.Date(closed_date)) %>%
  #'  mutate(created_date = as.Date(created_date)) %>%
  #'  mutate(updated_date = as.Date(resolution_action_updated_date)) %>%
  #'  mutate(closed_date = as.Date(closed_date)) %>%
  #'  mutate(closed_date = as.Date(closed_date)) 

  
#--------------------------------------------------------------------------------
# I recommend checking the year and month parameters separately. 
# and then separately check that month is an integer between 1 and 12. 
# Then you can be sure that as.Date will return a valid date.


#--------------------------------------------------------------------------------
install.packages("devtools")
devtools::install_github("beanumber/etl")
library(etl)
library(dplyr)
valid_months <- etl::valid_year_month(years, months, begin = "2010-01-01")
years <- 2010:2011
months <- 1:3
n <- 100
obj <- calls



#--------------------------------------------------------------------------
years <- 2015
months <- 1:12
num_calls = 100
nyc311 <- etl("nyc311", dir = "/Users/Priscilla/Desktop/nyc311")
download.file(valid_months$src[[1]], valid_months$lcl[[1]])
src_length <- 1
lapply(valid_months$new_lcl, FUN = DBI::dbWriteTable, conn = obj$con, 
       name = "calls", append = TRUE, sep = "|")

nyc311 %>%
  etl_extract(2013,1,100) %>%
  etl_transform(2013,1) %>%
  etl_load(2013,1)
nyc311

my_calls <- nyc311 %>%
  tbl("calls") %>%
  collect()

summary(nyc311)
download.file("https://data.cityofnewyork.us/resource/fhrw-4uyv.csv?$where=created_date%20between%20'2013-02-01'%20and%20'2013-02-28'&$limit=100",
              "/Users/Priscilla/Desktop/nyc311/raw/nyc311_2013_2.csv")
#------------------------------------------------------------------
install.packages("devtools")
R.Version()
tempdir()

require(etl)
require(dplyr)
#SQLite
x <- data.frame(variable_1 = c("1,1,1", "2,2,2"), variable_2 = c("a,b", "c,d"))
con_data = dbConnect(RSQLite::SQLite(), dbname="mysqlite")
dbWriteTable(con_data, x, name="data1",append=TRUE)

#MySQL
#system("mysql -e 'CREATE DATABASE IF NOT EXISTS testdata;'")
db <- src_mysql("testdata", )
db <- src_mysql(dbname = "testdata", host = "localhost",
                user = "WencongLi",password = "P320718")
db
y <- write.csv(x, quote=TRUE)
#y NULL
con_data_2 = dbConnect(RMySQL::MySQL(), username = "WencongLi",
                       password = "P320718", 
                       host = "localhost",
                       dbname="testdata")
dbWriteTable(con_data_2, x, name = "data2")

#-----------------------------------------------------------------
#MySQL

#mysql -u WencongLi -p
#P320718
#select now();
#create databases nyc311;
#show databases;


nyc311 <- table("nyc311")
