context("test-media-user-stats")

test_that("trakt.user.stats works", {
  skip_on_cran()

  user <- "jemus42"

  userstats <- trakt.user.stats(user = user)

  expect_is(userstats, "list")
  expect_named(userstats, c(
    "movies", "shows", "seasons", "episodes",
    "network", "ratings"
  ))
})

test_that("trakt.media.stats does things", {
  skip_on_cran()

  stats_show <- trakt.shows.stats(target = "futurama")
  stats_mov <- trakt.movies.stats(target = "deadpool-2016")

  expect_is(stats_show, "tbl")
  expect_is(stats_mov, "tbl")
  expect_length(stats_show, 9)
  expect_length(stats_mov, 8)

  expect_identical(
    stats_show,
    trakt.shows.stats(target = "futurama")
  )

  stats_multi <- trakt.shows.stats(target = c("futurama", "breaking-bad"))
  expect_equal(nrow(stats_multi), 2)
})
