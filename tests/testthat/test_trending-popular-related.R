context("Trending, popular and related shows/movies")

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
  expect_is(trakt.shows.related(target = "game-of-thrones", extended = "min"), "data.frame")
  expect_is(trakt.shows.related(target = "game-of-thrones", extended = "full"), "data.frame")
})

test_that("trakt.movies.related returns data.frame", {
  expect_is(trakt.movies.related(target = "tron-legacy-2010", extended = "min"), "data.frame")
  expect_is(trakt.movies.related(target = "tron-legacy-2010", extended = "full"), "data.frame")
})
