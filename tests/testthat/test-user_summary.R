test_that("user_profile", {
	skip_on_cran()
	)

	vcr::local_cassette("user_profile")
	nm_min <- c("username", "private", "deleted", "user_name", "vip", "vip_ep", "user_slug")
	nm_full <- c(
		"username",
		"private",
		"deleted",
		"user_name",
		"vip",
		"vip_ep",
		"joined_at",
		"location",
		"about",
		"gender",
		"age",
		"user_slug",
		"avatar"
	)

	user <- "jemus42"

	user_profile(user) |>
		expect_tibble(min_cols = nm_min, exact_rows = 1)

	user_profile(user, extended = "full") |>
		expect_tibble(min_cols = nm_full, exact_rows = 1)

	user_profile(c("sean", user)) |>
		expect_tibble(min_cols = nm_min)
})
