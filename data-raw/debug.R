#Debug

#-------------------------------------------------------------------
#First Try
#SQLite Connection
x <- data.frame(variable_1 = c("1,1,1", "2,2,2"), variable_2 = c("a,b", "c,d"))
con_data = dbConnect(RSQLite::SQLite(), dbname="mysqlite")
dbWriteTable(con_data, x, name="data1",append=TRUE)

#MySQL Connection
#system("mysql -e 'CREATE DATABASE IF NOT EXISTS testdata;'")
db <- src_mysql("testdata", )
db <- src_mysql(dbname = "testdata", host = "localhost",
                user = "WencongLi",password = "P320718")

y <- write.csv(x, quote=TRUE)
y
#My question is that whenever I try to write "x" into a csv, "y" returns as NULL

con_data_2 = dbConnect(RMySQL::MySQL(), username = "WencongLi",
                       password = "P320718", 
                       host = "localhost",
                       dbname="testdata")
con_data_2
dbWriteTable(con_data_2, x, name = "data2")

#------------------------------------------------------------------
#Feedback from Ben 11/07/2016
x <- data.frame(variable_1 = c("1,1,1", "2,2,2"), 
                variable_2 = c("a,b", "c,d"))
write.csv(x, file = "test.csv")

#SQLite Connection
library(DBI)
library(RSQLite)
db_sqlite <- src_sqlite(path = tempfile(), create = TRUE)
dbWriteTable(db_sqlite$con, "test.csv", name = "fake", overwrite = TRUE)

#MySQL Connection
#system("mysql -e 'CREATE DATABASE IF NOT EXISTS test;'")
library(RMySQL)
db_mysql <- etl::src_mysql_cnf("test")
dbWriteTable(db_mysql$con, "test.csv", name = "fake", overwrite = TRUE)


#--------------------------------------------------------------------



