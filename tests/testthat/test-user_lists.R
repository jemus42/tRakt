test_that("user_lists does stuff", {
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

	user_lists("jemus42") |>
		expect_s3_class("tbl_df") |>
		expect_named(expected = list_names_min)

	list_names_full <- c(
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
		"joined_at",
		"location",
		"about",
		"gender",
		"age",
		"user_slug",
		"avatar"
	)

	user_lists("jemus42", extended = "full") |>
		expect_s3_class("tbl_df") |>
		expect_named(expected = list_names_full)
})

test_that("user_list gets stuff", {
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

	user_list("jemus42", list_id = 2121308) |>
		expect_s3_class("tbl_df") |>
		expect_named(expected = list_names_min)

	list_names_full <- c(
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
		"joined_at",
		"location",
		"about",
		"gender",
		"age",
		"user_slug",
		"avatar"
	)

	user_list("jemus42", list_id = 2121308, extended = "full") |>
		expect_s3_class("tbl_df") |>
		expect_named(expected = list_names_full)
})
