test_that("user_list_items are correct", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user-user-list-items_basic")

	# Can't think of anything better than reference cases :/
	user_list_items(
		user = "jemus42",
		list_id = 2171659,
		extended = "min"
	) |>
		expect_s3_class("tbl_df")

	user_list_items(
		user = "jemus42",
		list_id = 2171659,
		extended = "full"
	) |>
		expect_s3_class("tbl_df")

	user_list_items(
		user = "sp1ti",
		list_id = "anime-winter-season-2018-2019",
		extended = "min"
	) |>
		expect_s3_class("tbl_df")

	user_list_items(
		user = "sp1ti",
		list_id = "anime-winter-season-2018-2019",
		extended = "full"
	) |>
		expect_s3_class("tbl_df")
})
