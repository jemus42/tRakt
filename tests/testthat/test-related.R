context("test-related")

test_that("trakt.related works", {
  show <- "futurama"
  movie <- "inception-2010"

  rel_show <- trakt.shows.related(target = show)
  rel_show_min <- trakt.shows.related(target = show, extended = "min")
  rel_show_max <- trakt.shows.related(target = show, extended = "full")

  expect_is(rel_show, "tbl")
  expect_identical(rel_show, rel_show_min)
  expect_gt(ncol(rel_show_max), ncol(rel_show))
  expect_equal(nrow(rel_show), 10)

  expect_identical(
    rbind(
      trakt.shows.related(target = show),
      trakt.shows.related(target = show)
    ),
    trakt.shows.related(target = c(show, show))
  )

  rel_movie <- trakt.movies.related(target = movie)
  rel_movie_min <- trakt.movies.related(target = movie, extended = "min")
  rel_movie_max <- trakt.movies.related(target = movie, extended = "full")

  expect_is(rel_movie, "tbl")
  expect_identical(rel_movie, rel_movie_min)
  expect_gt(ncol(rel_movie_max), ncol(rel_movie))
  expect_equal(nrow(rel_movie), 10)

  # Error conditions ----
  expect_error(trakt.movies.related(target = NA))
  expect_error(trakt.movies.related(target = movie, extended = "a lot"))
})
