test_that("comments_trending & co work", {
	skip_on_cran()
	)

	vcr::local_cassette("comments_trending_and_co")
	comments_trending("reviews") |>
		expect_s3_class("tbl_df")

	comments_recent("shouts") |>
		expect_s3_class("tbl_df")

	comments_updates() |>
		expect_s3_class("tbl_df")
})
