context("Show data")
skip_on_cran()

test_that("trakt.show.people returns data.frame", {
  expect_is(trakt.show.people(target = "game-of-thrones", extended = "min"), "data.frame")
  expect_is(trakt.show.people(target = "game-of-thrones", extended = "full"), "data.frame")
})

test_that("trakt.show.ratings returns data.frame", {
  expect_is(trakt.show.ratings(target = "game-of-thrones"), "list")
  expect_is(trakt.show.ratings(target = "game-of-thrones")$distribution, "data.frame")
})

test_that("trakt.show.season returns data.frame", {
  expect_is(trakt.show.season(target = "game-of-thrones", 1, extended = "min"), "data.frame")
  expect_is(trakt.show.season(target = "game-of-thrones", 2, extended = "full"), "data.frame")
})

test_that("trakt.show.summary returns data.frame", {
  expect_is(trakt.show.summary(target = "game-of-thrones", extended = "min"), "list")
  expect_is(trakt.show.summary(target = "game-of-thrones", extended = "full"), "list")
})
