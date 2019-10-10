test_that("shows_(next|last)_episode() works", {
  shows_next_episode("one-piece") %>%
    expect_is("tbl_df")

  shows_last_episode("one-piece") %>%
    expect_is("tbl_df") %>%
    expect_length(7) %>%
    nrow() %>%
    expect_equal(1)

  shows_last_episode("one-piece", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_length(15) %>%
    nrow() %>%
    expect_equal(1)
})
