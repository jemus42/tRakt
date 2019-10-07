context("User / Ratings")

test_that("user_ratings works", {
  skip_on_cran()

  user <- "jemus42"

  user_ratings(user = user, type = "shows") %>%
    expect_is("tbl")
  user_ratings(user = user, type = "seasons") %>%
    expect_is("tbl")
  user_ratings(user = user, type = "episodes") %>%
    expect_is("tbl")
  user_ratings(user = user, type = "movies") %>%
    expect_is("tbl")


  # Error conditions ----
  expect_error(user_ratings(user = -1))
  expect_error(user_ratings(user = user, type = "seven"))
  expect_error(user_ratings(user = user, type = "movies", rating = -2))
  expect_error(user_ratings(user = user, type = "movies", rating = NA))
})
