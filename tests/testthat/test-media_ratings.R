test_that("media_ratings works", {
	skip_on_cran()

	id_show <- "futurama"
	id_movie <- "inception-2010"

	ratings_show <- shows_ratings(id = id_show)
	ratings_movie <- movies_ratings(id = id_movie)

	expected_names <- c("rating", "votes", "distribution", "id", "type")

	expect_tibble(ratings_show, min_cols = expected_names)
	expect_tibble(ratings_movie, min_cols = expected_names)

	expect_equal(nrow(shows_ratings(id = rep(id_show, 2))), 2)
})

test_that("season and episode ratings work", {
	skip_on_cran()

	id <- c("futurama", "the-simpsons")
	season <- 1:2
	episode <- 3:4

	ratings_season_names <- c(
		"rating",
		"votes",
		"distribution",
		"id",
		"season"
	)
	ratings_episode_names <- c(
		"rating",
		"votes",
		"distribution",
		"id",
		"season",
		"episode"
	)

	seasons_ratings(id, season) |>
		expect_tibble(min_cols = ratings_season_names)

	episodes_ratings(id, season, episode) |>
		expect_tibble(min_cols = ratings_episode_names)
})
