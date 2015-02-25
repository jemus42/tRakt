context("User-specific functions")

#### General user data ####
test_that("trakt.user.stats returns proper object", {
  expect_is(trakt.user.stats(to.data.frame = TRUE), "data.frame")
  expect_is(trakt.user.stats(to.data.frame = FALSE), "list")
})

test_that("trakt.user.collection returns data.frame", {
  expect_is(trakt.user.collection(type = "shows"), "data.frame")
  expect_is(trakt.user.collection(type = "movies"), "data.frame")
})

test_that("trakt.user.watched returns data.frame", {
  expect_is(trakt.user.watched(type = "shows"), "data.frame")
  expect_is(trakt.user.watched(type = "shows.extended"), "data.frame")
  expect_is(trakt.user.watched(type = "movies"), "data.frame")
})

test_that("trakt.user.watchlist returns data.frame", {
  expect_is(trakt.user.watchlist(type = "shows"), "data.frame")
  expect_is(trakt.user.watchlist(type = "movies"), "data.frame")
})

test_that("trakt.user.ratings returns data.frame", {
  expect_is(trakt.user.ratings(type = "shows"), "data.frame")
  expect_is(trakt.user.ratings(type = "movies"), "data.frame")
  expect_is(trakt.user.ratings(type = "shows", rating = 10), "data.frame")
  expect_is(trakt.user.ratings(type = "movies", rating = 10), "data.frame")
})

#### Network related ####
test_that("trakt.user.followers returns data.frame", {
  expect_is(trakt.user.followers(), "data.frame")
})

test_that("trakt.user.following returns data.frame", {
  expect_is(trakt.user.following(), "data.frame")
})

test_that("trakt.user.friends returns data.frame", {
  expect_is(trakt.user.friends(), "data.frame")
})

