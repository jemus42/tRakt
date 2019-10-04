context("User / Watched")

test_that("user_watched works", {
  skip_on_cran()

  user <- "jemus42"

  # shows ----
  watched_shows <- user_watched(user = user, type = "shows", noseasons = TRUE)
  watched_shows_full <- user_watched(user = user, type = "shows", noseasons = FALSE)

  expect_is(watched_shows, "tbl")
  expect_is(watched_shows_full, "tbl")

  expect_true(rlang::has_name(watched_shows_full, "seasons"))

  expect_equal(setdiff(names(watched_shows_full), names(watched_shows)), "seasons")

  # movies ----
  watched_movies <- user_watched(user = user, type = "movies")

  expect_is(watched_movies, "tbl")

  # error conditions ----
  expect_error(user_watched(user = user, type = "schnitzel"))
  expect_error(user_watched(user = ""))
})
