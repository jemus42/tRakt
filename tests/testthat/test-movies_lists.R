test_that("media lists work", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("media_lists_basic")
	media_list_names <- c(
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

	movies_lists("190430", type = "personal", limit = 5) |>
		expect_tibble(min_cols = media_list_names, exact_rows = 5)

	shows_lists("46241") |>
		expect_tibble(min_cols = media_list_names)

	seasons_lists("46241", season = 1) |>
		expect_tibble(min_cols = media_list_names)

	episodes_lists("46241", season = 1, episode = 1) |>
		expect_tibble(min_cols = media_list_names)

	people_lists("david-tennant") |>
		expect_tibble(min_cols = media_list_names)
})
