context("Trending, popular and related shows/movies")

sample_show <- "game-of-thrones"
multi_show <- c("game-of-thrones", "breaking-bad")
sample_movie <- "tron-legacy-2010"
multi_movie <- c("tron-legacy-2010", "the-imitation-game-2014")

test_that("trakt.shows.popular returns data.frame", {
  expect_is(trakt.shows.popular(extended = "min"), "data.frame")
  expect_is(trakt.shows.popular(extended = "full"), "data.frame")
})

test_that("trakt.movies.popular returns data.frame", {
  expect_is(trakt.movies.popular(extended = "min"), "data.frame")
  expect_is(trakt.movies.popular(extended = "full"), "data.frame")
})

test_that("trakt.shows.trending returns data.frame", {
  expect_is(trakt.shows.trending(extended = "min"), "data.frame")
  expect_is(trakt.shows.trending(extended = "full"), "data.frame")
})

test_that("trakt.movies.trending returns data.frame", {
  expect_is(trakt.movies.trending(extended = "min"), "data.frame")
  expect_is(trakt.movies.trending(extended = "full"), "data.frame")
})

test_that("trakt.shows.related returns data.frame", {
  expect_is(trakt.shows.related(target = sample_show, extended = "min"), "data.frame")
  expect_is(trakt.shows.related(target = sample_show, extended = "full"), "data.frame")
  expect_is(trakt.shows.related(target = multi_show, extended = "min"), "data.frame")
})

test_that("trakt.movies.related returns data.frame", {
  expect_is(trakt.movies.related(target = sample_movie, extended = "min"), "data.frame")
  expect_is(trakt.movies.related(target = sample_movie, extended = "full"), "data.frame")
  expect_is(trakt.movies.related(target = multi_movie, extended = "min"), "data.frame")
})
