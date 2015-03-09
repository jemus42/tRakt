context("Movie functions")

sample_movie <- "the-imitation-game-2014"
multi_movie  <- c("tron-legacy-2010", "the-imitation-game-2014")

test_that("trakt.movie.people returns a list of data.frames", {
  people <- trakt.movie.people(sample_movie)
  expect_is(people, "list")
  expect_is(people$cast, "data.frame")
  expect_is(people$crew, "list")
})

test_that("trakt.movie.ratings returns data.frame", {
  expect_is(trakt.movie.ratings(target = sample_movie), "data.frame")
  expect_is(trakt.movie.ratings(target = sample_movie)$distribution, "data.frame")
})

test_that("trakt.movie.ratings with multiple inputs returns correct structures", {
  ratings <- trakt.movie.ratings(target = multi_movie)
  expect_is(ratings, "list")
  expect_is(ratings[1], "list")
  expect_is(ratings[[1]][[1]], "data.frame")
  expect_is(ratings[[1]][[2]], "data.frame")
})

test_that("trakt.movie.summary returns correct structure", {
  expect_is(trakt.movie.summary(target = sample_movie, extended = "min"), "list")
  expect_is(trakt.movie.summary(target = sample_movie, extended = "full"), "list")
  expect_is(trakt.movie.summary(target = sample_movie,
                               extended = "min", force_data_frame = TRUE), "data.frame")
  expect_is(trakt.movie.summary(target = sample_movie,
                               extended = "full", force_data_frame = TRUE), "data.frame")
  expect_is(trakt.movie.summary(target = sample_movie,
                               extended = "full,images", force_data_frame = TRUE), "data.frame")
  expect_is(trakt.movie.summary(target = multi_movie, extended = "min"), "data.frame")
})

test_that("trakt.movie.releases returns correct structure", {
  rel <- trakt.movie.releases(sample_movie)
  expect_is(rel, "data.frame")
  expect_is(rel$country, "character")
  expect_is(rel$certification, "character")
  expect_is(rel$release_date, "POSIXct")
  ## Multiple input
  rel <- trakt.movie.releases(target = multi_movie)
  expect_is(rel, "data.frame")
  expect_is(rel$country, "character")
  expect_is(rel$certification, "character")
  expect_is(rel$release_date, "POSIXct")
  expect_is(rel$movie, "character")
  expect_equal(unique(rel$movie), multi_movie)
})

test_that("trakt.movie.watching returns returns correct structure", {
  watching <- trakt.movie.watching(sample_movie, extended = "min")
  if (!is.null(watching)){
    expect_is(watching, "data.frame")
  }
  watching <- trakt.movie.watching(sample_movie, extended = "full")
  if (!is.null(watching)){
    expect_is(watching, "data.frame")
    expect_is(watching$joined_at, "POSIXct")
  }
  watching <- trakt.movie.watching(multi_movie, extended = "min")
  if (!is.null(watching)){
    expect_is(watching, "data.frame")
  }
})
