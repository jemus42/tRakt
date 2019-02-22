context("test-user-watched")

test_that("trakt.user.watched works", {
  skip_on_cran()
  
  user <- "jemus42"

  # shows ----
  watched_shows <- trakt.user.watched(user = user, type = "shows")

  expect_is(watched_shows, "tbl")

  # shows.extended ----
  watched_shows.ext <- trakt.user.watched(user = user, type = "shows.extended")

  expect_is(watched_shows.ext, "tbl")

  # movies ----
  watched_movies <- trakt.user.watched(user = user, type = "movies")

  expect_is(watched_movies, "tbl")


  # error conditions ----
  expect_error(trakt.user.watched(user = user, type = "schnitzel"))
  expect_error(trakt.user.watched(user = ""))
})
