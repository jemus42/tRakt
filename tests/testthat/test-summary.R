context("Summary")

test_that("shows_summary works", {
  skip_on_cran()

  target <- c("breaking-bad", "dexter")
  show_min_df <- shows_summary(target)
  show_full_df <- shows_summary(target, extended = "full")

  expect_is(show_min_df, "tbl")
  expect_is(show_full_df, "tbl")

  expect_true(length(show_min_df) < length(show_full_df))

  expect_identical(
    shows_summary(c(target, target)),
    rbind(show_min_df, show_min_df)
  )
})

test_that("movies_summary works", {
  skip_on_cran()

  target <- "deadpool-2016"
  movie_min_df <- movies_summary(target)

  movie_full_df <- movies_summary(target, extended = "full")

  expect_is(movie_min_df, "tbl")
  expect_is(movie_full_df, "tbl")

  expect_true(length(movie_min_df) < length(movie_full_df))

  expect_identical(
    movies_summary(c(target, target)),
    rbind(movie_min_df, movie_min_df)
  )
})
