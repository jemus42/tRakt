context("test-trakt-get_all_episodes")

test_that("it works", {
  skip_on_cran()
  result <- trakt.get_all_episodes(c("futurama", "breaking-bad"))

  expect_is(result, "tbl")
  expect_true(nrow(result) > 120)
  expect_true(ncol(result) > 6)
  expect_equal(unique(result$show), c("futurama", "breaking-bad"))
})
