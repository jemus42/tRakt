context("Related media")

test_that("media_related works", {
  skip_on_cran()

  show <- "futurama"
  movie <- "inception-2010"

  rel_show <- shows_related(target = show)
  rel_show_min <- shows_related(target = show, extended = "min")
  rel_show_max <- shows_related(target = show, extended = "full")

  expect_is(rel_show, "tbl")
  expect_identical(rel_show, rel_show_min)
  expect_gt(ncol(rel_show_max), ncol(rel_show))
  expect_equal(nrow(rel_show), 10)

  expect_identical(
    rbind(
      shows_related(target = show),
      shows_related(target = show)
    ),
    shows_related(target = c(show, show))
  )

  rel_movie <- movies_related(target = movie)
  rel_movie_min <- movies_related(target = movie, extended = "min")
  rel_movie_max <- movies_related(target = movie, extended = "full")

  expect_is(rel_movie, "tbl")
  expect_identical(rel_movie, rel_movie_min)
  expect_gt(ncol(rel_movie_max), ncol(rel_movie))
  expect_equal(nrow(rel_movie), 10)

  # Error conditions ----
  expect_error(movies_related(target = NA))
  expect_error(movies_related(target = movie, extended = "a lot"))
})
