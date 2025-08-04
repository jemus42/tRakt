test_that("user_list_comments works", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user_list_comments")
	nm <- c(
		"id",
		"comment",
		"spoiler",
		"review",
		"parent_id",
		"created_at",
		"updated_at",
		"replies",
		"likes",
		"user_rating",
		"username",
		"private",
		"deleted",
		"user_name",
		"vip",
		"vip_ep",
		"user_slug"
	)

	user_list_comments("donxy", "1248149") |>
		expect_tibble(min_cols = nm, exact_rows = 10)
})
