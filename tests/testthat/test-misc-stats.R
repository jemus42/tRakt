context("test-misc-stats")

test_that("trakt.user.stats works", {
  skip_on_cran()
  skip_if_not(class(getOption("trakt.headers")) == "request")
  user <- "jemus42"

  userstats <- trakt.user.stats(user = user)

  expect_is(userstats, "list")
  expect_named(userstats, c("movies", "shows", "seasons", "episodes",
                            "network", "ratings"))
})
