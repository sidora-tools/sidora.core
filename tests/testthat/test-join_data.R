context("join_data()")

test_that("check_completeness passes or fails under different conditions", {
  expect_true(check_completeness(c("a", "b", "c"), c("a", "b", "c", "d", "e")))
  expect_true(check_completeness(c("b", "c", "a"), c("a", "b", "c", "d", "e")))
  expect_true(check_completeness(c("a", "b"), c("a", "b", "c", "d", "e")))
  expect_false(check_completeness(c("a", "c"), c("a", "b", "c", "d", "e")))
  expect_false(check_completeness(c("a", "d"), c("a", "b", "c", "d", "e")))
})
