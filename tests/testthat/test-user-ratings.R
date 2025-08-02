test_that("user_ratings works", {
	skip_on_cran()

	user <- "jemus42"

	# A single user ----
	user_ratings(user = user, type = "shows") |>
		expect_s3_class("tbl") |>
		expect_length(10)
	user_ratings(user = user, type = "seasons") |>
		expect_s3_class("tbl") |>
		expect_length(5)
	user_ratings(user = user, type = "episodes") |>
		expect_s3_class("tbl") |>
		expect_length(5)
	user_ratings(user = user, type = "movies") |>
		expect_s3_class("tbl") |>
		expect_length(9)

	# Multiple users ----
	user_ratings(c(user, user), type = "shows") |>
		expect_s3_class("tbl_df") |>
		expect_length(11)
	user_ratings(c(user, user), type = "movies") |>
		expect_s3_class("tbl_df") |>
		expect_length(10)

	# These are very slow :/
	user_ratings(c(user, user), type = "seasons") |>
		expect_s3_class("tbl_df") |>
		expect_length(6)

	user_ratings(c(user, user), type = "episodes") |>
		expect_s3_class("tbl_df") |>
		expect_length(6)

	# Error conditions ----
	expect_error(user_ratings(user = -1))
	expect_error(user_ratings(user = user, type = "seven"))
	expect_error(user_ratings(user = user, type = "movies", rating = -2))
	expect_error(user_ratings(user = user, type = "movies", rating = NA))
})
