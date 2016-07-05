context("nyc311")

## TODO: Rename context
## TODO: Add more tests

test_that("instantiation works", {
  ontime <- etl("nyc311") 
  expect_is(ontime, c("etl_nyc311", "src_sql"))
})


test_that("download works", {
  url <- "http://data.cityofnewyork.us/resource/fhrw-4uyv.csv?$where=created_date%20between%20'2016-06-06'%20and%20'2016-06-07'&$limit=10"
  lcl <- tempfile()
  
  download <-
    {
      first_try <- tryCatch(
        utils::download.file(url, lcl,method = "curl"),
        error = function(e){warning(e)},
        finally = 'method = "curl" fails')
      
      ifelse(class(first_try) == "NULL", 
             print("Download succeeded."), 
             tryCatch(utils::download.file(url, lcl),
                      error = function(e){warning(e)},
                      finally = 'method = "auto" fails'))
      }
  expect_equal(download, 0)
})



test_that("mysql works", {
  if (require(RMySQL) & mysqlHasDefault()) {
    db <- src_mysql(default.file = "~/.my.cnf", 
                    groups = "rs-dbi", dbname = "test", 
                    user = NULL, password = NULL)
    test_dir <- "~/Desktop/nyc311"
    if (dir.exists(test_dir)) {
      expect_s3_class(ontime_mysql <- etl("airlines", db = db, dir = test_dir), "src_mysql")
      ontime_mysql %>% etl_init()
      expect_message(ontime_mysql %>% etl_update(years = 2011, months = 1, n = 10), "success")
      expect_output(print(ontime_mysql), "calls")
      expect_equal(ontime_mysql %>% tbl("calls") %>% collect(n = Inf) %>% nrow(), 448620)
    }
  }
})

