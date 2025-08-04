test_that("user_comments", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user_comments_basic")
	nm <- c(
		"type",
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
		"user_slug",
		"title",
		"year",
		"trakt",
		"slug",
		"tvdb",
		"imdb",
		"tmdb",
		"episode_season",
		"episode_number",
		"episode_title",
		"episode_trakt",
		"episode_tvdb",
		"episode_imdb",
		"episode_tmdb",
		"season_number",
		"season_trakt",
		"season_tvdb",
		"season_tmdb"
	)

	user_comments("jemus42") |>
		expect_tibble(min_cols = nm, min_rows = 10)

	nm_movies <- c(
		"type",
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
		"user_slug",
		"title",
		"year",
		"trakt",
		"slug",
		"imdb",
		"tmdb"
	)

	result <- user_comments("jemus42", type = "movie") |>
		expect_tibble(min_cols = nm_movies)

	result |>
		pluck("type") |>
		unique() |>
		expect_equal("movie")

	user_comments("sofakissen") |>
		expect_tibble(exact_rows = 0)
})
