context("test-media-summary")

test_that("trakt.shows.summary works", {
  skip_on_cran()

  target <- "breaking-bad"
  show_min_df <- trakt.shows.summary(target)
  show_full_df <- trakt.shows.summary(target, extended = "full")

  expect_is(show_min_df, "tbl")
  expect_is(show_full_df, "tbl")

  expect_true(length(show_min_df) < length(show_full_df))

  expect_identical(
    trakt.shows.summary(c(target, target)),
    rbind(show_min_df, show_min_df)
  )
})

test_that("trakt.movies.summary works", {
  skip_on_cran()

  target <- "deadpool-2016"
  movie_min_df <- trakt.movies.summary(target)

  movie_full_df <- trakt.movies.summary(target, extended = "full")

  expect_is(movie_min_df, "tbl")
  expect_is(movie_full_df, "tbl")

  expect_true(length(movie_min_df) < length(movie_full_df))

  expect_identical(
    trakt.movies.summary(c(target, target)),
    rbind(movie_min_df, movie_min_df)
  )
})
