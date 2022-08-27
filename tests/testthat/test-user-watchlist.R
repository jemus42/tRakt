test_that("user_watchlist works", {
  skip_on_cran()

  user <- "sean"

  res_default <- user_watchlist(user = user)
  res_shows <- user_watchlist(user = user, type = "shows")
  res_movies <- user_watchlist(user = user, type = "movies")

  expect_identical(res_default, res_movies)
  expect_is(res_shows, "tbl")
  expect_is(res_movies, "tbl")


  user_watchlist(user = c(user, user)) %>%
    expect_is("tbl_df") %>%
    expect_length(12)

  # FIXME: Find no shows test case
  # expect_identical(
  #   tibble::tibble(),
  #   user_watchlist(user = "jemus42", type = "shows")
  # )
})
