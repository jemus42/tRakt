test_that("_watching works", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("media_watching")
	movies_watching("deadpool-2016") |>
		expect_s3_class("tbl_df")

	shows_watching("the-simpsons", extended = "full") |>
		expect_s3_class("tbl_df")

	seasons_watching("the-simpsons", season = sample(2:29, 1)) |>
		expect_s3_class("tbl_df")

	episodes_watching("the-simpsons", season = sample(2:29, 1), episode = sample(19, 1)) |>
		expect_s3_class("tbl_df")
})
