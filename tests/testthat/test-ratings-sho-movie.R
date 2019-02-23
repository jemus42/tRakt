context("test-ratings-shows-movies")

test_that("trakt.[shows|movies].ratings works", {
  skip_on_cran()

  target_show <- "futurama"
  target_movie <- "inception-2010"

  ratings_show <- trakt.shows.ratings(target = target_show)
  ratings_movie <- trakt.movies.ratings(target = target_movie)

  expect_equal(ncol(ratings_show), 5)
  expect_equal(ncol(ratings_movie), 5)

  expected_names <- c("id", "type", "votes", "rating", "distribution")

  expect_named(ratings_show, expected_names)
  expect_named(ratings_movie, expected_names)

  expect_equal(nrow(trakt.shows.ratings(target = rep(target_show, 2))), 2)
})
