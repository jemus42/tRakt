test_that("user_profile", {
  nm_min <- c("username", "private", "user_name", "vip", "vip_ep", "user_slug")
  nm_full <- c(
    "username", "private", "user_name", "vip", "vip_ep", "joined_at",
    "location", "about", "gender", "age", "user_slug", "avatar"
  )

  user_profile("sean") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_min) %>%
    nrow() %>%
    expect_equal(1)

  user_profile("sean", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_full) %>%
    nrow() %>%
    expect_equal(1)

  user_profile(c("jemus42", "sean")) %>%
    expect_is("tbl_df") %>%
    expect_named(nm_min)
})
