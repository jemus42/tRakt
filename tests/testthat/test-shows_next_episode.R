test_that("shows_(next|last)_episode() works", {
	skip_on_cran()

	vcr::local_cassette("shows_next_last_episode_one_piece")

	res <- shows_next_episode("one-piece")

	skip_if(nrow(res) == 0, "Test case does not have a next episode")

	expect_s3_class(res, "tbl_df")

	shows_last_episode("one-piece") |>
		expect_tibble(
			min_cols = c("season", "number", "title", "trakt", "tvdb", "imdb", "tmdb"),
			exact_rows = 1
		)

	shows_last_episode("one-piece", extended = "full") |>
		expect_tibble(
			min_cols = c(
				"season",
				"number",
				"title",
				"number_abs",
				"overview",
				"rating",
				"votes",
				"comment_count",
				"first_aired",
				"updated_at",
				"available_translations",
				"runtime",
				"episode_type",
				"trakt",
				"tvdb",
				"imdb",
				"tmdb"
			),
			exact_rows = 1
		)
})
