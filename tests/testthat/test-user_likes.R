test_that("user_likes works", {
  skip_if_no_auth()

  user_likes(type = "comments") %>%
    expect_is("tbl_df") %>%
    expect_length(18)

  user_likes(type = "lists") %>%
    expect_is("tbl_df") %>%
    expect_length(22)
})
