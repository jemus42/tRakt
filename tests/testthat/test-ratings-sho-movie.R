context("test-media-ratings")

test_that("trakt.[shows|movies].ratings works", {
  skip_on_cran()

  target_show <- "futurama"
  target_movie <- "inception-2010"

  ratings_show <- trakt.shows.ratings(target = target_show)
  ratings_movie <- trakt.movies.ratings(target = target_movie)

  expect_equal(ncol(ratings_show), 5)
  expect_equal(ncol(ratings_movie), 5)

  expected_names <- c("rating", "votes", "distribution", "id", "type")

  expect_named(ratings_show, expected_names)
  expect_named(ratings_movie, expected_names)

  expect_equal(nrow(trakt.shows.ratings(target = rep(target_show, 2))), 2)
})

test_that("season and episode ratings work", {
  target <- c("futurama", "the-simpsons")
  season <- 1:2
  episode <- 1:2

  ratings_season_names <- c("rating", "votes", "distribution", "id", "season")
  ratings_episode_names <- c(ratings_season_names, "episode")

  trakt.seasons.ratings(target, season) %>%
    expect_is("tbl") %>%
    expect_named(ratings_season_names)


  trakt.episodes.ratings(target, season, episode) %>%
    expect_is("tbl") %>%
    expect_named(ratings_episode_names)
})
