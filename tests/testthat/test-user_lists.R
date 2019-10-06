test_that("user_lists does stuff", {

  list_names_min <- c("name", "description", "privacy", "display_numbers", "allow_comments",
                      "sort_by", "sort_how", "created_at", "updated_at", "item_count",
                      "comment_count", "likes", "trakt", "slug", "username", "private",
                      "user_name", "vip", "vip_ep", "user_slug")

  user_lists("jemus42") %>%
    expect_is("tbl_df") %>%
    expect_length(20) %>%
    expect_named(expected = list_names_min)

  list_names_full <- c("name", "description", "privacy", "display_numbers", "allow_comments",
                       "sort_by", "sort_how", "created_at", "updated_at", "item_count",
                       "comment_count", "likes", "trakt", "slug", "username", "private",
                       "user_name", "vip", "vip_ep", "joined_at", "location", "about",
                       "gender", "age", "user_slug", "avatar")

  user_lists("jemus42", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_length(20) %>%
    expect_named(expected = list_names_full)
})
