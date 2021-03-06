test_that("shows_summary works", {
  skip_on_cran()

  id <- c("breaking-bad", "dexter")
  show_min_df <- shows_summary(id)
  show_full_df <- shows_summary(id, extended = "full")

  expect_is(show_min_df, "tbl")
  expect_is(show_full_df, "tbl")

  expect_true(length(show_min_df) < length(show_full_df))

  expect_identical(
    shows_summary(c(id, id)),
    rbind(show_min_df, show_min_df)
  )
})

test_that("movies_summary works", {
  skip_on_cran()

  id <- "deadpool-2016"
  movie_min_df <- movies_summary(id)

  movie_full_df <- movies_summary(id, extended = "full")

  expect_is(movie_min_df, "tbl")
  expect_is(movie_full_df, "tbl")

  expect_true(length(movie_min_df) < length(movie_full_df))

  expect_identical(
    movies_summary(c(id, id)),
    rbind(movie_min_df, movie_min_df)
  )
})
