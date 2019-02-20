context("test-ratings-show-movie")

test_that("trakt.[show|movies].ratings works", {
  target_show <- "futurama"
  target_movie <- "inception-2010"

  ratings_show <- trakt.show.ratings(target = target_show)
  ratings_movie <- trakt.movie.ratings(target = target_movie)

  expect_equal(ncol(ratings_show), 3)
  expect_equal(ncol(ratings_movie), 3)

  expect_named(ratings_show, c("rating", "votes", "distribution"))
  expect_named(ratings_movie, c("rating", "votes", "distribution"))

  expect_equal(nrow(trakt.show.ratings(target = rep(target_show, 2))), 2)
})
