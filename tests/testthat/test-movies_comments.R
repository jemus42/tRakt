test_that("media comments work", {
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
    expect_s3_class("tbl_df") |>
    expect_named(media_comments_names_min) |>
    nrow() |>
    expect_lte(10)

  shows_comments(46241, sort = "likes") |>
    expect_s3_class("tbl_df") |>
    expect_named(media_comments_names_min) |>
    nrow() |>
    expect_lte(10)

  seasons_comments(1388, season = 1, sort = "likes") |>
    expect_s3_class("tbl_df") |>
    expect_named(media_comments_names_min) |>
    nrow() |>
    expect_lte(10)

  episodes_comments(1388, season = 1, episode = 2, sort = "likes") |>
    expect_s3_class("tbl_df") |>
    expect_named(media_comments_names_min) |>
    nrow() |>
    expect_lte(10)
})
