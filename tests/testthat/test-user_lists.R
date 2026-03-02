test_that("user_lists does stuff", {
	skip_on_cran()

	vcr::local_cassette("user_lists_basic")

	# Note: "trakt" column gets disambiguated when user object also contains a trakt ID,
	# so we only check for columns that don't collide
	list_names_min <- c(
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
		"slug",
		"username",
		"private",
		"deleted",
		"user_name",
		"vip",
		"vip_ep",
		"user_slug"
	)

	user_lists("jemus42") |>
		expect_tibble(min_cols = list_names_min)
})

test_that("user_list gets stuff", {
	skip_on_cran()

	vcr::local_cassette("user_list_single")

	list_names_min <- c(
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
		"slug",
		"username",
		"private",
		"deleted",
		"user_name",
		"vip",
		"vip_ep",
		"user_slug"
	)

	user_list("jemus42", list_id = 2121308) |>
		expect_tibble(min_cols = list_names_min)
})
