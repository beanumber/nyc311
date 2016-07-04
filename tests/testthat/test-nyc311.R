context("nyc311")

## TODO: Rename context
## TODO: Add more tests

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



