test_that("user_likes works", {
  skip_if_no_auth()

  user_likes(type = "comments") |>
    expect_s3_class("tbl_df") |>
    expect_length(19)

  user_likes(type = "lists") |>
    expect_s3_class("tbl_df") |>
    expect_length(25)
})
