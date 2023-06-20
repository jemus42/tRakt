test_that("Popular/trending lists work", {

  list_names <- c("name", "description", "privacy", "share_link", "type", "display_numbers",
    "allow_comments", "sort_by", "sort_how", "created_at", "updated_at",
    "item_count", "comment_count", "likes", "trakt", "slug", "username",
    "private", "user_name", "vip", "vip_ep", "user_slug")

  lists_popular() %>%
    expect_is("tbl_df") %>%
    expect_named(list_names) %>%
    nrow() %>%
    expect_equal(10)

  lists_trending() %>%
    expect_is("tbl_df") %>%
    expect_named(list_names) %>%
    nrow() %>%
    expect_equal(10)
})
