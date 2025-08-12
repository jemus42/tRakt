test_that("user_ratings works", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user-user-ratings_basic")

	# Use real user with smaller collection for more manageable test data
	user <- "sean"

	# Define minimum expected columns for different rating types
	shows_cols <- c("rated_at", "rating", "type", "title", "year", "trakt", "slug")
	movies_cols <- c("rated_at", "rating", "type", "title", "year", "trakt", "slug")
	episodes_cols <- c("rated_at", "rating", "type", "episode", "show")
	
	# A single user with limited results ----
	user_ratings(user = user, type = "shows", limit = 3) |>
		expect_tibble(min_cols = shows_cols)
	user_ratings(user = user, type = "seasons", limit = 2) |>
		expect_tibble()  # May be empty for this user
	user_ratings(user = user, type = "episodes", limit = 2) |>
		expect_tibble(min_cols = episodes_cols)
	user_ratings(user = user, type = "movies", limit = 3) |>
		expect_tibble(min_cols = movies_cols)

	# Multiple users with limited results
	user_ratings(c("sean", "jemus42"), type = "movies", limit = 2) |>
		expect_tibble(min_cols = c(movies_cols, "user"))

	# Error conditions ----
	expect_error(user_ratings(user = -1))
	expect_error(user_ratings(user = user, type = "seven"))
	expect_error(user_ratings(user = user, type = "movies", rating = -2))
	expect_error(user_ratings(user = user, type = "movies", rating = NA))
})
