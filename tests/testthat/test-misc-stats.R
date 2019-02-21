context("test-misc-stats")

test_that("trakt.user.stats works", {
  skip_on_cran()

  if (is.null(getOption("trakt.headers"))) {
    message("trakt.headers are NULL. Why?")
    get_trakt_credentials()
  }

  user <- "jemus42"

  userstats <- trakt.user.stats(user = user)

  expect_is(userstats, "list")
  expect_named(userstats, c(
    "movies", "shows", "seasons", "episodes",
    "network", "ratings"
  ))
})

test_that("trakt.stats does things", {
  stats_show <- trakt.stats(target = "futurama", type = "shows")
  stats_mov <- trakt.stats(target = "deadpool-2016", type = "movies")

  expect_is(stats_show, "tbl")
  expect_is(stats_mov, "tbl")
  expect_length(stats_show, 9)
  expect_length(stats_mov, 8)

  expect_identical(
    stats_show,
    trakt.stats(target = "futurama")
  )

  stats_multi <- trakt.stats(target = c("futurama", "breaking-bad"), type = "shows")
  expect_equal(nrow(stats_multi), 2)
})
