context("test-get-all-episodes")

test_that("trakt.get_all_episodes works", {
  skip_on_cran()

  result <- trakt.get_all_episodes(c("futurama", "breaking-bad"))

  expect_is(result, "tbl")
  expect_true(nrow(result) > 120)
  expect_true(ncol(result) > 6)
  expect_equal(unique(result$show), c("futurama", "breaking-bad"))

  x1 <- trakt.get_all_episodes("futurama", season_nums = 3)
  x2 <- trakt.get_all_episodes("futurama", season_nums = 1:3)

  expect_identical(x1, x2)
})
