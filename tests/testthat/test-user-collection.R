test_that("user_collection works", {
	skip_on_cran()

	vcr::local_cassette("user_collection_basic")

	# Use real user with smaller collection for more manageable test data
	user <- "sean"

	# Define minimum expected columns
	shows_cols <- c("last_collected_at", "last_updated_at", "title", "year", "trakt", "slug")
	movies_cols <- c("collected_at", "updated_at", "type", "title", "year", "trakt", "slug")

	# Focus primarily on movies (smaller data) and minimal show testing
	user_collection(user = user, type = "movies") |>
		expect_tibble(min_cols = movies_cols)

	# Test with multiple users for movies
	user_collection(user = c("sean", "jemus42"), type = "movies") |>
		expect_tibble(min_cols = c(movies_cols, "user"))

	# Minimal show test - just verify the function works, accept large data for now
	col_sho <- user_collection(user = user, type = "shows", unnest_episodes = FALSE)
	col_sho |>
		expect_tibble(min_cols = shows_cols)

	# Error conditions ----
	expect_error(user_collection(user = -1))
	expect_error(user_collection(user = "totallynotarealuser"))
	expect_error(user_collection(user = user, type = "wurst"))
})

# The unnesting thing ----

test_that("user_collection works with episode unnesting", {
	skip_if_not_installed("tidyr")
	skip_on_cran()

	vcr::local_cassette("user_collection_unnest_episodes")

	# Use real user with smaller collection for more manageable test data
	user <- "sean"

	# Define expected columns for unnested episodes
	unnested_cols <- c(
		"last_collected_at",
		"last_updated_at",
		"title",
		"year",
		"trakt",
		"slug",
		"season",
		"episode",
		"collected_at"
	)

	col_eps <- user_collection(user = user, type = "shows", unnest_episodes = TRUE)

	# Test with limited unnested data from real user
	col_eps |>
		expect_tibble(min_cols = unnested_cols)

	# Check that collected_at is properly parsed as POSIXct
	expect_s3_class(col_eps$collected_at, "POSIXct")
})
