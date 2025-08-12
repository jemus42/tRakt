test_that("media_watching works", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("media_watching")
	
	# Define minimum expected columns for watching functions
	nm_min <- c(
		"username",
		"private",
		"deleted",
		"user_name",
		"vip",
		"vip_ep",
		"director",
		"user_slug"
	)
	
	nm_extended <- c(
		nm_min,
		"joined_at",
		"location",
		"about",
		"gender",
		"age",
		"avatar"
	)
	
	movies_watching("deadpool-2016") |>
		expect_tibble(min_cols = nm_min)

	shows_watching("the-simpsons", extended = "full") |>
		expect_tibble(min_cols = nm_extended)

	seasons_watching("the-simpsons", season = 9) |>
		expect_tibble(min_cols = nm_min)

	# Test episodes_watching with Game of Thrones S01E01 which typically has viewers
	episodes_watching("game-of-thrones", season = 1, episode = 1) |>
		expect_tibble(min_cols = nm_min)
})
