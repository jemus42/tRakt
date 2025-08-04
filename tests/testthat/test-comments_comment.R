test_that("comments_comment()", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("comments_comment")
	nm_min <- c(
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

	comments_comment(c("236397", "112561")) |>
		expect_api_response(min_cols = nm_min, exact_rows = 2)
})


test_that("comments_replies()", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("comments_replies")
	nm_min <- c(
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

	comments_replies(c("236397", "236397")) |>
		expect_api_response(min_cols = nm_min, exact_rows = 2)
})


test_that("comments_likes()", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("comments_likes")
	nm_min <- c(
		"liked_at",
		"username",
		"private",
		"deleted",
		"user_name",
		"vip",
		"vip_ep",
		"user_slug"
	)

	comments_likes(c("236397", "236397")) |>
		expect_api_response(min_cols = nm_min)
})

test_that("comments_item()", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("comments_item")
	nm_min <- c(
		"type",
		"title",
		"year",
		"trakt",
		"slug",
		"tvdb",
		"imdb",
		"tmdb",
		"season",
		"episode",
		"episode_title",
		"episode_trakt",
		"episode_tvdb",
		"episode_imdb",
		"episode_tmdb"
	)

	comments_item(c("136632", "236397")) |>
		expect_api_response(min_cols = nm_min)
})
