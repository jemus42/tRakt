context("User / Ratings")

test_that("trakt.user.ratings works", {
  skip_on_cran()

  user <- "jemus42"

  trakt.user.ratings(user = user, type = "shows") %>%
    expect_is("tbl")
  trakt.user.ratings(user = user, type = "seasons") %>%
    expect_is("tbl")
  trakt.user.ratings(user = user, type = "episodes") %>%
    expect_is("tbl")
  trakt.user.ratings(user = user, type = "movies") %>%
    expect_is("tbl")


  # Error conditions ----
  expect_error(trakt.user.ratings(user = -1))
  expect_error(trakt.user.ratings(user = user, type = "seven"))
  expect_error(trakt.user.ratings(user = user, type = "movies", rating = -2))
  expect_error(trakt.user.ratings(user = user, type = "movies", rating = NA))
})
