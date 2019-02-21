context("test-user-watchlist")

test_that("trakt.user.watchlist works", {
  user <- "jemus42"

  res_default <- trakt.user.watchlist(user = user)
  res_shows <- trakt.user.watchlist(user = user, type = "shows")
  res_movies <- trakt.user.watchlist(user = user, type = "movies")

  expect_identical(res_default, res_movies)
  expect_is(res_shows, "tbl")
  expect_is(res_movies, "tbl")
})
