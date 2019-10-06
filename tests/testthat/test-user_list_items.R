test_that("user_list_items are correct", {
  skip_on_cran()

  # Can't think of anything better than reference cases :/
  user_list_items("jemus42", list_id = 2171659, extended = "min") %>%
    expect_is("tbl_df") %>%
    expect_length(11) %>%
    nrow() %>%
    expect_equal(7)

  user_list_items("jemus42", list_id = 2171659, extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_length(33) %>%
    nrow() %>%
    expect_equal(7)

  user_list_items("sp1ti", list_id = "anime-winter-season-2018-2019", extended = "min") %>%
    expect_is("tbl_df") %>%
    expect_length(13) %>%
    nrow() %>%
    expect_equal(72)

  user_list_items("sp1ti", list_id = "anime-winter-season-2018-2019", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_length(37) %>%
    nrow() %>%
    expect_equal(72)

  user_list_items("ZoMa_TGM", list_id = 6562799, extended = "min") %>%
    expect_is("tbl_df") %>%
    expect_length(9)

  user_list_items("ZoMa_TGM", list_id = 6562799, extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_length(14)

})
