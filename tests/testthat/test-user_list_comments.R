test_that("user_list_comments works", {
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
