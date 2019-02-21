context("test-misc-stats")

test_that("trakt.user.stats works", {
  skip_on_cran()

  if (is.null(getOption("trakt.headers"))) {
    message("trakt.headers are NULL. Why?")
    get_trakt_credentials()
  }

  user <- "jemus42"

  userstats <- trakt.user.stats(user = user)

  expect_is(userstats, "list")
  expect_named(userstats, c("movies", "shows", "seasons", "episodes",
                            "network", "ratings"))
})
