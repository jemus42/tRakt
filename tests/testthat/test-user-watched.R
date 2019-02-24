context("test-user-watched")

test_that("trakt.user.watched works", {
  skip_on_cran()

  user <- "jemus42"

  # shows ----
  watched_shows <- trakt.user.watched(user = user, type = "shows")
  watched_shows_full <- trakt.user.watched(user = user, type = "shows", extended = "full")

  expect_is(watched_shows, "tbl")
  expect_is(watched_shows_full, "tbl")

  # shows.extended ----
  watched_shows.ext <- trakt.user.watched(user = user, type = "shows", noseasons = FALSE)

  expect_is(watched_shows.ext, "tbl")
  expect_true(tibble::has_name(watched_shows.ext, "seasons"))

  # movies ----
  watched_movies <- trakt.user.watched(user = user, type = "movies")

  expect_is(watched_movies, "tbl")


  # error conditions ----
  expect_error(trakt.user.watched(user = user, type = "schnitzel"))
  expect_error(trakt.user.watched(user = ""))
})
