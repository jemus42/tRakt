test_that("user_list_comments works", {
  nm <- c(
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
    "user_name",
    "vip",
    "vip_ep",
    "user_slug"
  )

  user_list_comments("donxy", "1248149") |>
    expect_is("tbl_df") |>
    expect_named(nm) |>
    nrow() |>
    expect_equal(10)
})
