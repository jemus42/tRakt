test_that("episodes_summary works", {
  episode_summary_names_min <- c(
    "id", "season", "episode", "title", "trakt", "tvdb", "imdb", "tmdb"
  )

  episodes_summary("breaking-bad") |>
    expect_length(8) |>
    expect_named(episode_summary_names_min) |>
    nrow() |>
    expect_equal(1)

  # Multiple shows
  episodes_summary(c("breaking-bad", "futurama")) |>
    expect_is("tbl_df") |>
    expect_length(8) |>
    expect_named(episode_summary_names_min) |>
    nrow() |>
    expect_equal(2)

  # Multiple seasons
  res <- episodes_summary("breaking-bad", season = 1:2) |>
    expect_length(8) |>
    expect_named(episode_summary_names_min)

  expect_equal(nrow(res), 2)
  expect_equal(res$season, 1:2)
  expect_equal(res$episode, c(1, 1))

  # Multiple episodes
  res <- episodes_summary("breaking-bad", episode = 1:2) |>
    expect_length(8) |>
    expect_named(episode_summary_names_min)

  expect_equal(nrow(res), 2)
  expect_equal(res$season, c(1, 1))
  expect_equal(res$episode, c(1, 2))
})
