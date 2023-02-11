test_that("shows_(next|last)_episode() works", {
  res <- shows_next_episode("detective-conan")

  skip_if(nrow(res) == 0, "Test case does not have a next episode")

  expect_is(res, "tbl_df")

  shows_last_episode("one-piece") %>%
    expect_is("tbl_df") %>%
    expect_length(7) %>%
    nrow() %>%
    expect_equal(1)

  shows_last_episode("one-piece", extended = "full") %>%
    expect_is("tbl_df") %>%
    expect_length(16) %>%
    nrow() %>%
    expect_equal(1)
})
