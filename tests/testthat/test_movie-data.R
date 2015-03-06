context("Movie functions")

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

test_that("trakt.movie.summary returns correct structure", {
  expect_is(trakt.movie.summary(target = "tron-legacy-2010", extended = "min"), "list")
  expect_is(trakt.movie.summary(target = "tron-legacy-2010", extended = "full"), "list")
  expect_is(trakt.movie.summary(target = "tron-legacy-2010",
                               extended = "min", force_data_frame = TRUE), "data.frame")
  expect_is(trakt.movie.summary(target = "tron-legacy-2010",
                               extended = "full", force_data_frame = TRUE), "data.frame")
  expect_is(trakt.movie.summary(target = "tron-legacy-2010",
                               extended = "full,images", force_data_frame = TRUE), "data.frame")
})

test_that("trakt.movie.releases returns correct structure", {
  rel <- trakt.movie.releases("tron-legacy-2010")
  expect_is(rel, "data.frame")
  expect_is(rel$country, "character")
  expect_is(rel$certification, "character")
  expect_is(rel$release_date, "POSIXct")
})

test_that("trakt.movie.watching returns returns correct structure", {
  watching <- trakt.movie.watching("the-imitation-game-2014", extended = "min")
  if (!identical(watching, list())){
    expect_is(watching, "data.frame")
  }
  watching <- trakt.movie.watching("the-imitation-game-2014", extended = "full")
  if (!identical(watching, list())){
    expect_is(watching, "data.frame")
    expect_is(watching$joined_at, "POSIXct")
  }
})
