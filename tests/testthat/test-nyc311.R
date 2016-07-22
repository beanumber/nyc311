context("nyc311")

## TODO: Rename context
## TODO: Add more tests

test_that("instantiation works", {
  calls <- etl("nyc311") 
  expect_is(calls, c("etl_nyc311", "src_sql"))
})


test_that("sqlite works", {
  if (require(RSQLite)) {
    expect_s3_class(calls_sqlite <- etl("nyc311"), "src_sqlite")
    expect_message(calls_sqlite %>% etl_init(), "Could not find")
    expect_message(calls_sqlite %>% etl_update(years = 2011, months = 1, num_calls = 100), "Writing NYC311 data")
    expect_output(print(calls_sqlite), "calls")
    expect_equal(calls_sqlite %>% tbl("calls") %>% collect(n = Inf) %>% nrow(), 100)
  }
})



test_that("mysql works", {
  if (require(RMySQL) & mysqlHasDefault()) {
    db <- src_mysql(default.file = "~/.my.cnf", 
                    groups = "rs-dbi", dbname = "test", 
                    user = NULL, password = NULL)
    expect_s3_class(calls_mysql <- etl("nyc311", db = db, dir = test_dir), "src_mysql")
    expect_message(calls_mysql %>% etl_init(), "Could not find")
    expect_message(calls_mysql %>% etl_update(years = 2011, months = 1, num_calls = 100), "Writing NYC311 data")
    expect_output(print(calls_mysql), "calls")
    expect_equal(calls_mysql %>% tbl("calls") %>% collect(n = Inf) %>% nrow(), 100)
  }
})

