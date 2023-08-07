test_that("media lists work", {
  media_list_names <- c(
    "name", "description", "privacy", "share_link", "type", "display_numbers",
    "allow_comments", "sort_by", "sort_how", "created_at", "updated_at",
    "item_count", "comment_count", "likes", "trakt", "slug", "username",
    "private", "user_name", "vip", "vip_ep", "user_slug"
  )

  movies_lists("190430", type = "personal", limit = 5) |>
    expect_is("tbl_df") |>
    expect_named(media_list_names) |>
    nrow() |>
    expect_equal(5)

  shows_lists("46241") |>
    expect_is("tbl_df") |>
    expect_named(media_list_names) |>
    nrow() |>
    expect_lte(10)

  seasons_lists("46241", season = 1) |>
    expect_is("tbl_df") |>
    expect_named(media_list_names) |>
    nrow() |>
    expect_lte(10)

  episodes_lists("46241", season = 1, episode = 1) |>
    expect_is("tbl_df") |>
    expect_named(media_list_names) |>
    nrow() |>
    expect_lte(10)

  people_lists("david-tennant") |>
    expect_is("tbl_df") |>
    expect_named(media_list_names) |>
    nrow() |>
    expect_lte(10)
})
