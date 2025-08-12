test_that("episodes_summary works", {
	skip_on_cran()
	)

	vcr::local_cassette("episodes_summary_basic")
	episode_summary_names_min <- c(
		"id",
		"season",
		"episode",
		"title",
		"trakt",
		"tvdb",
		"imdb",
		"tmdb"
	)

	episodes_summary("breaking-bad") |>
		expect_tibble(min_cols = episode_summary_names_min, exact_rows = 1)

	# Multiple shows
	episodes_summary(c("breaking-bad", "futurama")) |>
		expect_tibble(min_cols = episode_summary_names_min, exact_rows = 2)

	# Multiple seasons
	res <- episodes_summary("breaking-bad", season = 1:2) |>
		expect_tibble(min_cols = episode_summary_names_min)

	expect_equal(nrow(res), 2)
	expect_equal(res$season, 1:2)
	expect_equal(res$episode, c(1, 1))

	# Multiple episodes
	res <- episodes_summary("breaking-bad", episode = 1:2) |>
		expect_tibble(min_cols = episode_summary_names_min)

	expect_equal(nrow(res), 2)
	expect_equal(res$season, c(1, 1))
	expect_equal(res$episode, c(1, 2))
})
