context("getter functions")

test_that("get_con() behaves as expected", {
  skip_on_travis()
  expect_error(get_con("Wurstbrot", con))
  ind_table_con <- get_con("TAB_Site", con)
  expect_s3_class(ind_table_con, c("tbl_MariaDBConnection", "tbl_dbi", "tbl_sql", "tbl_lazy", "tbl"), exact = T)
  expect_equal(ncol(ind_table_con), 17)
})

test_that("get_con_list() behaves as expected", {
  skip_on_travis()
  expect_equal(names(get_con_list(tab = c("TAB_Site", "TAB_Individual"), con = con)), c("TAB_Site", "TAB_Individual"))
  table_list <- get_con_list(con = con)
  expect_type(table_list, "list")
  expect_length(table_list, length(pandora_tables))
  for (i in 1:length(table_list)) {
    expect_s3_class(table_list[[i]], c("tbl_MariaDBConnection", "tbl_dbi", "tbl_sql", "tbl_lazy", "tbl"), exact = T)
  }
})

test_that("get_df() behaves as expected", {
  skip_on_travis()
  ind_table_df <- get_df("TAB_Site", con)
  expect_s3_class(ind_table_df, c("tbl_df", "tbl", "data.frame"), exact = T)
  expect_equal(ncol(ind_table_df), 17)
  expect_gt(nrow(ind_table_df), 1000)
  expect_false(as.logical(unique(ind_table_df$site.Deleted)))
})

test_that("get_df_list() behaves as expected", {
  skip_on_travis()
  table_list <- get_df_list(tab = c("TAB_Site", "TAB_Individual"), con)
  expect_equal(names(table_list), c("TAB_Site", "TAB_Individual"))
  expect_type(table_list, "list")
  for (i in 1:length(table_list)) {
    expect_s3_class(table_list[[i]], c("tbl_df", "tbl", "data.frame"), exact = T)
  }
})
