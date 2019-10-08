test_that("media translations work", {
  nm_movie <- c("title", "overview", "tagline", "language")

  movies_translations("193972") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_movie)

  nm_show <- c("title", "overview", "language")

  shows_translations("breaking-bad") %>%
    expect_is("tbl_df") %>%
    expect_named(nm_show)

  episodes_translations("breaking-bad", 1, 3) %>%
    expect_is("tbl_df") %>%
    expect_named(nm_show)
})
