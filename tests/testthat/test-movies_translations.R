test_that("media translations work", {
  nm_movie <- c("title", "overview", "tagline", "language", "country")
  movies_translations("193972") |>
    expect_is("tbl_df") |>
    expect_named(nm_movie)

  nm_show <- c("title", "overview", "tagline", "language", "country")
  shows_translations("breaking-bad") |>
    expect_is("tbl_df") |>
    expect_named(nm_show)

  nm_ep <- c("title", "overview", "language", "country")
  episodes_translations("breaking-bad", 1, 3) |>
    expect_is("tbl_df") |>
    expect_named(nm_ep)
})
