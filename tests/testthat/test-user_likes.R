test_that("user_likes works", {
	skip_if_no_auth()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user-likes_auth")

	user_likes(type = "comments") |>
		expect_s3_class("tbl_df")

	user_likes(type = "lists") |>
		expect_s3_class("tbl_df")
})
