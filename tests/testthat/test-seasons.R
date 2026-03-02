test_that("seasons_episodes works", {
	skip_on_cran()

	vcr::local_cassette("seasons_episodes_futurama")

	id <- "futurama"

	min_names <- c(
		"season",
		"episode",
		"title",
		"trakt",
		"tvdb",
		"imdb",
		"tmdb"
	)

	min_s1_single <- seasons_episodes(id = id, seasons = 1, extended = "min")
	full_s1_single <- seasons_episodes(id = id, seasons = 1, extended = "full")

	# Structural integrity
	expect_tibble(min_s1_single, min_cols = min_names, exact_rows = 9)
	expect_tibble(full_s1_single, min_cols = min_names, exact_rows = 9)

	# Error conditions
	expect_error(seasons_episodes(id = id, seasons = NA))
	expect_error(seasons_episodes(id = id, seasons = "seven"))
	expect_error(seasons_episodes(id = id, seasons = NULL))
	# Non-existent season returns empty tibble via VCR replay
	expect_identical(seasons_episodes(id = id, seasons = 1123), tibble::tibble())

	# Multi-length input seasons
	expect_identical(
		rbind(
			seasons_episodes(id = id, seasons = 1),
			seasons_episodes(id = id, seasons = 2)
		),
		seasons_episodes(id = id, seasons = 1:2)
	)
})

test_that("seasons_summary works", {
	skip_on_cran()

	vcr::local_cassette("seasons_summary_breaking_bad")

	id <- "breaking-bad"

	# Note that dropping unaired only workes if extended = full so this is weird
	result_min <- seasons_summary(
		id = id,
		extended = "min",
		drop_specials = TRUE,
		drop_unaired = TRUE
	)
	result_max <- seasons_summary(
		id = id,
		extended = "full",
		drop_specials = TRUE,
		drop_unaired = TRUE
	)

	expect_tibble(result_min, expected_class = "tbl")
	expect_tibble(result_max, expected_class = "tbl")

	expect_equal(nrow(result_min), nrow(result_max))

	expect_identical(
		rbind(
			seasons_summary(id),
			seasons_summary(id)
		),
		seasons_summary(c(id, id))
	)

	# Non-existent show returns empty tibble via VCR replay
	expect_identical(seasons_summary(id = "bvkjqbkqjbf"), tibble::tibble())
})

test_that("seasons_summary works for episodes and matches seasons_episodes", {
	skip_on_cran()

	vcr::local_cassette("seasons_summary_episodes_utopia")

	id <- "utopia"
	res <- seasons_summary(id, extended = "full", episodes = TRUE)

	expect_s3_class(res, "tbl_df")
	expect_type(res$episodes, "list")
	expect_length(res$episodes, 2)

	res$episodes[[1]] |>
		expect_tibble(expected_class = "tbl", exact_rows = 6)

	expect_identical(
		res$episodes[[1]],
		seasons_episodes(id, seasons = 1, extended = "full")
	)
})

test_that("seasons_season works", {
	skip_on_cran()

	vcr::local_cassette("seasons_season")

	id <- "utopia"

	res_min <- seasons_season(id, seasons = 1, extended = "min")

	res_min |>
		expect_tibble(min_cols = c("number", "trakt", "tvdb", "tmdb"))

	res_full <- seasons_season(id, seasons = 2, extended = "full")

	res_full |>
		expect_tibble(
			min_cols = c(
				"number",
				"rating",
				"votes",
				"episode_count",
				"aired_episodes",
				"title",
				"overview",
				"first_aired",
				"updated_at",
				"network",
				"trakt",
				"tvdb",
				"tmdb"
			)
		)

	expect_identical(
		seasons_season(id, seasons = 1:2, extended = "min"),
		rbind(
			seasons_season(id, seasons = 1, extended = "min"),
			seasons_season(id, seasons = 2, extended = "min")
		)
	)
})
