test_that("user_comments", {
  nm <- c(
    "type", "id", "comment", "spoiler", "review", "parent_id",
    "created_at", "updated_at", "replies", "likes", "user_rating",
    "username", "private", "user_name", "vip", "vip_ep", "user_slug",
    "title", "year", "trakt", "slug", "tvdb", "imdb", "tmdb", "episode_season",
    "episode_number", "episode_title", "episode_trakt", "episode_tvdb",
    "episode_imdb", "episode_tmdb", "season_number", "season_trakt",
    "season_tvdb", "season_tmdb"
  )

  user_comments("jemus42") %>%
    expect_is("tbl_df") %>%
    expect_named(nm) %>%
    nrow() %>%
    expect_gte(10)

  nm_movies <- c(
    "type", "id", "comment", "spoiler", "review", "parent_id",
    "created_at", "updated_at", "replies", "likes", "user_rating",
    "username", "private", "user_name", "vip", "vip_ep", "user_slug",
    "title", "year", "trakt", "slug", "imdb", "tmdb"
  )

  user_comments("jemus42", type = "movie") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_movies) %>%
    pluck("type") %>%
    unique() %>%
    expect_equal("movie")

  user_comments("sofakissen") %>%
    expect_is("tbl_df")
})
