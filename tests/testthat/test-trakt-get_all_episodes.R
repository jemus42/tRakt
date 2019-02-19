context("test-trakt-get_a_lot")

test_that("trakt.get_all_episodes works", {
  skip_on_cran()
  result <- trakt.get_all_episodes(c("futurama", "breaking-bad"))

  expect_is(result, "tbl")
  expect_true(nrow(result) > 120)
  expect_true(ncol(result) > 6)
  expect_equal(unique(result$show), c("futurama", "breaking-bad"))
})

test_that("trakt.get_full_showdata works", {
  skip_on_cran()
  result <- trakt.get_full_showdata("Breaking Bad")

  expect_is(result, "list")
  expect_named(result, c("info", "summary", "seasons", "episodes"))
  expect_true(nrow(result$episodes) > 40)
  expect_true(ncol(result$episodes) > 6)
})
