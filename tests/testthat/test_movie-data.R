context("Movie functions")
skip_on_cran()

test_that("trakt.movie.people returns a list of data.frames", {
  people <- trakt.movie.people("tron-legacy-2010")
  expect_is(people, "list")
  expect_is(people$cast, "data.frame")
  expect_is(people$crew, "list")
})

test_that("trakt.movie.ratings returns data.frame", {
  expect_is(trakt.movie.ratings(target = "tron-legacy-2010"), "list")
  expect_is(trakt.movie.ratings(target = "tron-legacy-2010")$distribution, "data.frame")
})

test_that("trakt.movie.summary returns list", {
  expect_is(trakt.movie.summary(target = "tron-legacy-2010", extended = "min"), "list")
  expect_is(trakt.movie.summary(target = "tron-legacy-2010", extended = "full"), "list")
})
