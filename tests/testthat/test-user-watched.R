context("User / Watched")

test_that("trakt.user.watched works", {
  skip_on_cran()

  user <- "jemus42"

  # shows ----
  watched_shows <- trakt.user.watched(user = user, type = "shows", noseasons = TRUE)
  watched_shows_full <- trakt.user.watched(user = user, type = "shows", noseasons = FALSE)

  expect_is(watched_shows, "tbl")
  expect_is(watched_shows_full, "tbl")

  expect_true(rlang::has_name(watched_shows_full, "seasons"))

  expect_equal(setdiff(names(watched_shows_full), names(watched_shows)), "seasons")

  # movies ----
  watched_movies <- trakt.user.watched(user = user, type = "movies")

  expect_is(watched_movies, "tbl")

  # error conditions ----
  expect_error(trakt.user.watched(user = user, type = "schnitzel"))
  expect_error(trakt.user.watched(user = ""))
})
