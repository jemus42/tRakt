test_that("comments_item works", {
  # A movie

  nm_movie_min <- c("type", "title", "year", "trakt", "slug", "imdb", "tmdb")
  nm_movie_full <- c(
    "type", "title", "year", "tagline", "overview", "released",
    "runtime", "country", "trailer", "homepage", "rating", "votes",
    "comment_count", "updated_at", "language", "available_translations",
    "genres", "certification", "trakt", "slug", "imdb", "tmdb"
  )

  comments_item("236397") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_movie_min) %>%
    nrow() %>%
    expect_equal(1)

  comments_item("236397", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_movie_full) %>%
    nrow() %>%
    expect_equal(1)

  # A show
  nm_show_min <- c("type", "title", "year", "trakt", "slug", "tvdb", "imdb", "tmdb")
  nm_show_full <- c(
    "type", "title", "year", "overview", "first_aired", "runtime",
    "certification", "country", "trailer", "homepage", "status",
    "rating", "votes", "comment_count", "network", "updated_at",
    "language", "available_translations", "genres", "aired_episodes",
    "airs_day", "airs_time", "airs_timezone", "trakt", "slug", "tvdb",
    "imdb", "tmdb"
  )

  comments_item("120768") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_show_min) %>%
    nrow() %>%
    expect_equal(1)

  comments_item("120768", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_show_full) %>%
    nrow() %>%
    expect_equal(1)

  # A season
  nm_season_min <- c(
    "type", "title", "year", "trakt", "slug", "tvdb", "imdb", "tmdb",
    "season", "season_trakt", "season_tvdb", "season_tmdb"
  )
  nm_season_full <- c(
    "type", "title", "year", "overview", "first_aired", "runtime",
    "certification", "country", "trailer", "homepage", "status",
    "rating", "votes", "comment_count", "network", "updated_at",
    "language", "available_translations", "genres", "aired_episodes",
    "airs_day", "airs_time", "airs_timezone", "trakt", "slug", "tvdb",
    "imdb", "tmdb", "season", "season_rating", "season_votes", "season_episode_count",
    "season_aired_episodes", "season_title", "season_overview", "season_first_aired",
    "season_network", "season_trakt", "season_tvdb", "season_tmdb"
  )

  comments_item("140265") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_season_min) %>%
    nrow() %>%
    expect_equal(1)

  comments_item("140265", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_season_full) %>%
    nrow() %>%
    expect_equal(1)

  # An episode
  nm_episode_min <- c(
    "type", "title", "year", "trakt", "slug", "tvdb", "imdb", "tmdb",
    "season", "episode", "episode_title", "episode_trakt", "episode_tvdb",
    "episode_imdb", "episode_tmdb"
  )
  nm_episode_full <- c(
    "type", "title", "year", "overview", "first_aired", "runtime",
    "certification", "country", "trailer", "homepage", "status",
    "rating", "votes", "comment_count", "network", "updated_at",
    "language", "available_translations", "genres", "aired_episodes",
    "airs_day", "airs_time", "airs_timezone", "trakt", "slug", "tvdb",
    "imdb", "tmdb", "season", "episode", "episode_title", "episode_number_abs",
    "episode_overview", "episode_rating", "episode_votes", "episode_comment_count",
    "episode_first_aired", "episode_updated_at", "episode_available_translations",
    "episode_runtime", "episode_trakt", "episode_tvdb", "episode_imdb",
    "episode_tmdb"
  )

  comments_item("136632") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_episode_min) %>%
    nrow() %>%
    expect_equal(1)

  comments_item("136632", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_episode_full) %>%
    nrow() %>%
    expect_equal(1)
})
