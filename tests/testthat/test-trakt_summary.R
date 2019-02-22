context("test-trakt_summary")

test_that("trakt.show.summary works", {
  skip_on_cran()
  
  target <- "breaking-bad"
  show_min_list <- trakt.show.summary(target, force_data_frame = FALSE)
  show_min_df <- trakt.show.summary(target, force_data_frame = TRUE)

  show_full_list <- trakt.show.summary(target,
    extended = "full",
    force_data_frame = FALSE
  )
  show_full_df <- trakt.show.summary(target,
    extended = "full",
    force_data_frame = TRUE
  )

  expect_is(show_min_list, "list")
  expect_is(show_min_df, "tbl")
  expect_is(show_full_list, "list")
  expect_is(show_full_df, "tbl")

  expect_true(length(show_min_list) < length(show_full_list))
  expect_true(length(show_min_df) < length(show_full_df))

  expect_identical(
    trakt.show.summary(c(target, target)),
    rbind(show_min_df, show_min_df)
  )
})

test_that("trakt.movie.summary works", {
  skip_on_cran()
  
  target <- "deadpool-2016"
  movie_min_list <- trakt.movie.summary(target, force_data_frame = FALSE)
  movie_min_df <- trakt.movie.summary(target, force_data_frame = TRUE)

  movie_full_list <- trakt.movie.summary(target,
    extended = "full",
    force_data_frame = FALSE
  )
  movie_full_df <- trakt.movie.summary(target,
    extended = "full",
    force_data_frame = TRUE
  )

  expect_is(movie_min_list, "list")
  expect_is(movie_min_df, "tbl")
  expect_is(movie_full_list, "list")
  expect_is(movie_full_df, "tbl")

  expect_true(length(movie_min_list) < length(movie_full_list))
  expect_true(length(movie_min_df) < length(movie_full_df))

  expect_identical(
    trakt.movie.summary(c(target, target)),
    rbind(movie_min_df, movie_min_df)
  )
})
