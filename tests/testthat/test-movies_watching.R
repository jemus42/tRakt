test_that("media_watching works", {
	skip_on_cran()

	vcr::local_cassette("media_watching")

	# Watching endpoints return whoever is currently watching, which may be empty.
	# We can only verify the result is a tibble, not specific columns.
	movies_watching("deadpool-2016") |>
		expect_s3_class("tbl_df")

	shows_watching("the-simpsons", extended = "full") |>
		expect_s3_class("tbl_df")

	seasons_watching("the-simpsons", season = 9) |>
		expect_s3_class("tbl_df")

	episodes_watching("game-of-thrones", season = 1, episode = 1) |>
		expect_s3_class("tbl_df")
})
