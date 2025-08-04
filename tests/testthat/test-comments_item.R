test_that("comments_item works", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("comments_item_works")
	# A movie

	nm_movie_min <- c("type", "title", "year", "trakt", "slug", "imdb", "tmdb")
	nm_movie_full <- c(
		"type",
		"title",
		"year",
		"tagline",
		"overview",
		"released",
		"runtime",
		"country",
		"status",
		"rating",
		"votes",
		"comment_count",
		"trailer",
		"homepage",
		"updated_at",
		"language",
		"languages",
		"available_translations",
		"genres",
		"certification",
		"trakt",
		"slug",
		"imdb",
		"tmdb"
	)

	comments_item("236397") |>
		expect_tibble(min_cols = nm_movie_min, exact_rows = 1)

	comments_item("236397", extended = "full") |>
		expect_tibble(min_cols = nm_movie_full, exact_rows = 1)

	# A show
	nm_show_min <- c("type", "title", "year", "trakt", "slug", "tvdb", "imdb", "tmdb")
	nm_show_full <- c(
		"type",
		"title",
		"year",
		"tagline",
		"overview",
		"first_aired",
		"runtime",
		"certification",
		"country",
		"status",
		"rating",
		"votes",
		"comment_count",
		"trailer",
		"homepage",
		"network",
		"updated_at",
		"language",
		"languages",
		"available_translations",
		"genres",
		"aired_episodes",
		"airs_day",
		"airs_time",
		"airs_timezone",
		"trakt",
		"slug",
		"tvdb",
		"imdb",
		"tmdb"
	)

	have <- c(
		"type",
		"title",
		"year",
		"tagline",
		"overview",
		"first_aired",
		"runtime",
		"certification",
		"country",
		"trailer",
		"homepage",
		"status",
		"rating",
		"votes",
		"comment_count",
		"network",
		"updated_at",
		"language",
		"available_translations",
		"genres",
		"aired_episodes",
		"airs_day",
		"airs_time",
		"airs_timezone",
		"trakt",
		"slug",
		"tvdb",
		"imdb",
		"tmdb"
	)

	comments_item("120768") |>
		expect_tibble(min_cols = nm_show_min, exact_rows = 1)

	comments_item("120768", extended = "full") |>
		expect_tibble(min_cols = nm_show_full, exact_rows = 1)

	# A season
	nm_season_min <- c(
		"type",
		"title",
		"year",
		"trakt",
		"slug",
		"tvdb",
		"imdb",
		"tmdb",
		"season",
		"season_trakt",
		"season_tvdb",
		"season_tmdb"
	)
	nm_season_full <- c(
		"type",
		"title",
		"year",
		"tagline",
		"overview",
		"first_aired",
		"runtime",
		"certification",
		"country",
		"trailer",
		"homepage",
		"status",
		"rating",
		"votes",
		"comment_count",
		"network",
		"updated_at",
		"language",
		"languages",
		"available_translations",
		"genres",
		"aired_episodes",
		"airs_day",
		"airs_time",
		"airs_timezone",
		"trakt",
		"slug",
		"tvdb",
		"imdb",
		"tmdb",
		"season",
		"season_rating",
		"season_votes",
		"season_episode_count",
		"season_aired_episodes",
		"season_title",
		"season_overview",
		"season_first_aired",
		"season_updated_at",
		"season_network",
		"season_trakt",
		"season_tvdb",
		"season_tmdb"
	)

	comments_item("140265") |>
		expect_tibble(min_cols = nm_season_min, exact_rows = 1)

	comments_item("140265", extended = "full") |>
		expect_tibble(min_cols = nm_season_full, exact_rows = 1)

	# An episode
	nm_episode_min <- c(
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
	nm_episode_full <- c(
		"type",
		"title",
		"year",
		"tagline",
		"overview",
		"first_aired",
		"runtime",
		"certification",
		"country",
		"trailer",
		"homepage",
		"status",
		"rating",
		"votes",
		"comment_count",
		"network",
		"updated_at",
		"language",
		"languages",
		"available_translations",
		"genres",
		"aired_episodes",
		"airs_day",
		"airs_time",
		"airs_timezone",
		"trakt",
		"slug",
		"tvdb",
		"imdb",
		"tmdb",
		"season",
		"episode",
		"episode_title",
		"episode_number_abs",
		"episode_overview",
		"episode_rating",
		"episode_votes",
		"episode_comment_count",
		"episode_first_aired",
		"episode_updated_at",
		"episode_available_translations",
		"episode_runtime",
		"episode_episode_type",
		"episode_trakt",
		"episode_tvdb",
		"episode_imdb",
		"episode_tmdb"
	)

	comments_item("136632") |>
		expect_tibble(min_cols = nm_episode_min, exact_rows = 1)

	comments_item("136632", extended = "full") |>
		expect_tibble(min_cols = nm_episode_full, exact_rows = 1)
})
