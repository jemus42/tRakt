context("Ratings")

test_that("media_ratings works", {
  skip_on_cran()

  target_show <- "futurama"
  target_movie <- "inception-2010"

  ratings_show <- shows_ratings(target = target_show)
  ratings_movie <- movies_ratings(target = target_movie)

  expect_equal(ncol(ratings_show), 5)
  expect_equal(ncol(ratings_movie), 5)

  expected_names <- c("rating", "votes", "distribution", "id", "type")

  expect_named(ratings_show, expected_names)
  expect_named(ratings_movie, expected_names)

  expect_equal(nrow(shows_ratings(target = rep(target_show, 2))), 2)
})

test_that("season and episode ratings work", {
  skip_on_cran()

  target <- c("futurama", "the-simpsons")
  season <- 1:2
  episode <- 3:4

  ratings_season_names <- c(
    "rating", "votes", "distribution", "id", "season"
  )
  ratings_episode_names <- c(
    "rating", "votes", "distribution", "id", "season", "episode"
  )

  seasons_ratings(target, season) %>%
    expect_is("tbl") %>%
    expect_named(ratings_season_names)

  episodes_ratings(target, season, episode) %>%
    expect_is("tbl") %>%
    expect_named(ratings_episode_names)
})
