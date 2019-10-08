test_that("comments_comment works", {
  nm_min <- c(
    "id", "comment", "spoiler", "review", "parent_id", "created_at",
    "updated_at", "replies", "likes", "user_rating", "username",
    "private", "user_name", "vip", "vip_ep", "user_slug"
  )

  comments_comment(c("236397", "112561")) %>%
    expect_is("tbl_df") %>%
    expect_named(nm_min) %>%
    nrow() %>%
    expect_equal(2)
})
