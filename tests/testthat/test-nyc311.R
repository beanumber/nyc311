context("nyc311")

## TODO: Rename context
## TODO: Add more tests

test_that("download works", {
  url <- "http://data.cityofnewyork.us/resource/fhrw-4uyv.csv?$where=created_date%20between%20'2016-06-06'%20and%20'2016-06-07'&$limit=10"
  lcl <- tempfile()
#  options()$download.file.method
  expect_equal(download.file(url, lcl), 0)
})
