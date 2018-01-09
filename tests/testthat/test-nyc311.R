context("nyc311")

## TODO: Rename context
## TODO: Add more tests

test_that("etl nyc311", {
  calls <- etl("nyc311")
  expect_s3_class(calls, c("etl_nyctaxi", "etl", "src_sqlite", "src_sql", "src"))
  expect_message(calls %>% etl_extract(yeears = 2010, months =1, num_calls = 10), "Extracting")
})
