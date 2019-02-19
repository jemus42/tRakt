context("User-specific functions")

sample_user <- "jemus42"
multi_user <- c("sofakissen", "Fenhl")

#### General user data ####
test_that("trakt.user.stats returns list", {
  expect_is(trakt.user.stats(user = sample_user), "list")
})

test_that("trakt.user.collection returns data.frame", {
  expect_is(trakt.user.collection(user = sample_user, type = "shows"), "data.frame")
  expect_is(trakt.user.collection(user = sample_user, type = "movies"), "data.frame")
})

test_that("trakt.user.watched returns data.frame", {
  expect_is(trakt.user.watched(user = sample_user, type = "shows"), "data.frame")
  expect_is(trakt.user.watched(user = sample_user, type = "shows.extended"), "data.frame")
  expect_is(trakt.user.watched(user = sample_user, type = "movies"), "data.frame")
})

test_that("trakt.user.watchlist returns data.frame", {
  expect_is(trakt.user.watchlist(user = sample_user, type = "shows", extended = "min"), "data.frame")
  expect_is(trakt.user.watchlist(user = sample_user, type = "shows", extended = "full"), "data.frame")
  expect_is(trakt.user.watchlist(user = sample_user, type = "movies", extended = "min"), "data.frame")
})

test_that("trakt.user.ratings returns data.frame", {
  expect_is(trakt.user.ratings(user = sample_user, type = "shows"), "data.frame")
  expect_is(trakt.user.ratings(user = sample_user, type = "movies"), "data.frame")
  expect_is(trakt.user.ratings(user = sample_user, type = "shows", rating = 10), "data.frame")
  expect_is(trakt.user.ratings(user = sample_user, type = "movies", rating = 10), "data.frame")
})

#### Network related ####
test_that("trakt.user.followers returns data.frame", {
  expect_is(trakt.user.followers(user = sample_user, extended = "min"), "data.frame")
  expect_is(trakt.user.followers(user = sample_user, extended = "full"), "data.frame")
  expect_is(trakt.user.followers(user = multi_user, extended = "min"), "data.frame")
})

test_that("trakt.user.following returns data.frame", {
  expect_is(trakt.user.following(user = sample_user, extended = "min"), "data.frame")
  expect_is(trakt.user.following(user = sample_user, extended = "full"), "data.frame")
  expect_is(trakt.user.following(user = multi_user, extended = "min"), "data.frame")
})

test_that("trakt.user.friends returns data.frame", {
  expect_is(trakt.user.friends(user = sample_user, extended = "min"), "data.frame")
  expect_is(trakt.user.friends(user = sample_user, extended = "full"), "data.frame")
  expect_is(trakt.user.friends(user = multi_user, extended = "min"), "data.frame")
})
