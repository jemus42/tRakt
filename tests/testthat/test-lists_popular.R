test_that("Popular/trending lists work", {
	skip_on_cran()

	vcr::local_cassette("lists_popular_and_trending")
	list_names <- c(
		"name",
		"description",
		"privacy",
		"share_link",
		"type",
		"display_numbers",
		"allow_comments",
		"sort_by",
		"sort_how",
		"created_at",
		"updated_at",
		"item_count",
		"comment_count",
		"likes",
		"trakt",
		"slug",
		"username",
		"private",
		"deleted",
		"user_name",
		"vip",
		"vip_ep",
		"user_slug"
	)

	lists_popular() |>
		expect_tibble(min_cols = list_names, exact_rows = 10)

	lists_trending() |>
		expect_tibble(min_cols = list_names, exact_rows = 10)
})
