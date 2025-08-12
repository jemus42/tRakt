test_that("media comments work", {
	skip_on_cran()
	)

	vcr::local_cassette("media_comments_basic")
	media_comments_names_min <- c(
		"id",
		"comment",
		"spoiler",
		"review",
		"parent_id",
		"created_at",
		"updated_at",
		"replies",
		"likes",
		"user_rating",
		"username",
		"private",
		"deleted",
		"user_name",
		"vip",
		"vip_ep",
		"user_slug"
	)

	movies_comments(193972) |>
		expect_tibble(min_cols = media_comments_names_min)

	shows_comments(46241, sort = "likes") |>
		expect_tibble(min_cols = media_comments_names_min)

	seasons_comments(1388, season = 1, sort = "likes") |>
		expect_tibble(min_cols = media_comments_names_min)

	episodes_comments(1388, season = 1, episode = 2, sort = "likes") |>
		expect_tibble(min_cols = media_comments_names_min)
})
