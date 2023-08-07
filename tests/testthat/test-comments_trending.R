test_that("comments_trending & co work", {
  comments_trending("reviews") |>
    expect_is("tbl_df")

  comments_recent("shouts") |>
    expect_is("tbl_df")

  comments_updates() |>
    expect_is("tbl_df")
})
