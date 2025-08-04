test_that("user_watched works", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user-user-watched_basic")

	user <- "jemus42"

	# shows ----
	watched_shows <- user_watched(user = user, type = "shows", noseasons = TRUE)
	watched_shows_full <- user_watched(user = user, type = "shows", noseasons = FALSE)

	expect_s3_class(watched_shows, "tbl")
	expect_s3_class(watched_shows_full, "tbl")

	expect_true(rlang::has_name(watched_shows_full, "seasons"))

	expect_equal(setdiff(names(watched_shows_full), names(watched_shows)), "seasons")

	# Multiples
	user_watched(user = c(user, user), type = "shows", noseasons = TRUE) |>
		expect_s3_class("tbl_df") |>
		expect_length(12)

	# movies ----
	user_watched(user = user, type = "movies") |>
		expect_s3_class("tbl_df") |>
		expect_length(9)

	# Multiples
	user_watched(user = c(user, user), type = "movies") |>
		expect_s3_class("tbl_df") |>
		expect_length(10)

	# error conditions ----
	expect_error(user_watched(user = user, type = "schnitzel"))
	expect_error(user_watched(user = ""))
})
