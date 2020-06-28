context("enforce_types()")

test_that("check an incorrectly loaded column type is fixed with enforce_types()", {
  test_df <- tibble::tribble(
    ~site.Id, ~site.Site_Id, ~site.Creation_Date, ~site.Deleted,
    "1", "AAA", "2020-01-01", "false",
    "2", "AAB", "2020-01-03", "true",
    "3", "AAC", "2020-02-02", "false"
  )
  
  out_df <- enforce_types(test_df)
  
  expect_is(out_df$site.Deleted, 'logical')
  
})
