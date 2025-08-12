test_that("user_watched works", {
	skip_on_cran()
	)

	vcr::local_cassette("user-user-watched_basic")

	# Use real user with smaller collection for more manageable test data
	user <- "sean"
	
	# Define minimum expected columns
	shows_base_cols <- c("plays", "last_watched_at", "last_updated_at", "title", "year", "trakt", "slug")
	movies_cols <- c("plays", "last_watched_at", "last_updated_at", "title", "year", "trakt", "slug")

	# shows ----
	watched_shows <- user_watched(user = user, type = "shows", noseasons = TRUE)
	watched_shows_full <- user_watched(user = user, type = "shows", noseasons = FALSE)

	# Test with limited results from real user
	watched_shows |>
		expect_tibble(min_cols = shows_base_cols)
	watched_shows_full |>
		expect_tibble(min_cols = shows_base_cols)

	# Test seasons column functionality
	expect_true(rlang::has_name(watched_shows_full, "seasons"))
	expect_equal(setdiff(names(watched_shows_full), names(watched_shows)), "seasons")

	# Multiple users
	user_watched(user = c("sean", "jemus42"), type = "shows", noseasons = TRUE) |>
		expect_tibble(min_cols = c(shows_base_cols, "user"))

	# movies ----
	user_watched(user = user, type = "movies") |>
		expect_tibble(min_cols = movies_cols)

	# Multiple users for movies
	user_watched(user = c("sean", "jemus42"), type = "movies") |>
		expect_tibble(min_cols = c(movies_cols, "user"))

	# error conditions ----
	expect_error(user_watched(user = user, type = "schnitzel"))
	expect_error(user_watched(user = ""))
})
