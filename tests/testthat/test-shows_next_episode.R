test_that("shows_(next|last)_episode() works", {
  res <- shows_next_episode("one-piece")

  skip_if(nrow(res) == 0, "Test case does not have a next episode")

  expect_s3_class(res, "tbl_df")

  shows_last_episode("one-piece") |>
    expect_s3_class("tbl_df") |>
    expect_named(c("season", "number", "title", "trakt", "tvdb", "imdb", "tmdb")) |>
    nrow() |>
    expect_equal(1)

  shows_last_episode("one-piece", extended = "full") |>
    expect_s3_class("tbl_df") |>
    expect_named(c(
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
    )) |>
    nrow() |>
    expect_equal(1)
})
