context("User-specific functions")

#### General user data ####
test_that("trakt.user.stats returns list", {
  expect_is(trakt.user.stats(user = "jemus42"), "list")
})

test_that("trakt.user.collection returns data.frame", {
  expect_is(trakt.user.collection(user = "jemus42", type = "shows"), "data.frame")
  expect_is(trakt.user.collection(user = "jemus42", type = "movies"), "data.frame")
})

test_that("trakt.user.watched returns data.frame", {
  expect_is(trakt.user.watched(user = "jemus42", type = "shows"), "data.frame")
  expect_is(trakt.user.watched(user = "jemus42", type = "shows.extended"), "data.frame")
  expect_is(trakt.user.watched(user = "jemus42", type = "movies"), "data.frame")
})

test_that("trakt.user.watchlist returns data.frame", {
  expect_is(trakt.user.watchlist(user = "jemus42", type = "shows", extended = "min"), "data.frame")
  expect_is(trakt.user.watchlist(user = "jemus42", type = "shows", extended = "full"), "data.frame")
  expect_is(trakt.user.watchlist(user = "jemus42", type = "movies", extended = "min"), "data.frame")
})

test_that("trakt.user.ratings returns data.frame", {
  expect_is(trakt.user.ratings(user = "jemus42", type = "shows"), "data.frame")
  expect_is(trakt.user.ratings(user = "jemus42", type = "movies"), "data.frame")
  expect_is(trakt.user.ratings(user = "jemus42", type = "shows", rating = 10), "data.frame")
  expect_is(trakt.user.ratings(user = "jemus42", type = "movies", rating = 10), "data.frame")
})

#### Network related ####
test_that("trakt.user.followers returns data.frame", {
  expect_is(trakt.user.followers(user = "jemus42", extended = "min"), "data.frame")
  expect_is(trakt.user.followers(user = "jemus42", extended = "full"), "data.frame")
})

test_that("trakt.user.following returns data.frame", {
  expect_is(trakt.user.following(user = "jemus42", extended = "min"), "data.frame")
  expect_is(trakt.user.following(user = "jemus42", extended = "full"), "data.frame")
})

test_that("trakt.user.friends returns data.frame", {
  expect_is(trakt.user.friends(user = "jemus42", extended = "min"), "data.frame")
  expect_is(trakt.user.friends(user = "jemus42", extended = "full"), "data.frame")
})

