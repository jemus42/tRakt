context("Stats")

test_that("trakt.user.stats works", {
  skip_on_cran()

  user <- "jemus42"

  userstats <- trakt.user.stats(user = user)

  expect_is(userstats, "list")
  expect_named(userstats, c(
    "movies", "shows", "seasons", "episodes",
    "network", "ratings"
  ))

  userstats <- trakt.user.stats(user = c(user, "sean"))
  expect_is(userstats, "list")
  expect_named(userstats, c(user, "sean"))
  expect_named(userstats[[user]], c(
    "movies", "shows", "seasons", "episodes",
    "network", "ratings"
  ))
})

test_that("trakt.media.stats does things", {
  skip_on_cran()

  trakt.shows.stats(target = "futurama") %>%
    expect_is("tbl") %>%
    expect_length(9) %>%
    nrow() %>%
    expect_equal(1)


  stats_mov <- trakt.movies.stats(target = "deadpool-2016") %>%
    expect_is("tbl") %>%
    expect_length(8) %>%
    nrow() %>%
    expect_equal(1)

  stats_multi <- trakt.shows.stats(target = c("futurama", "breaking-bad"))
  expect_equal(nrow(stats_multi), 2)
})

test_that("trakt.seasons.stats works", {
  trakt.seasons.stats("futurama", 1:2) %>%
    expect_is("tbl") %>%
    expect_length(9) -> res

  res$season %>% expect_equal(1:2)
})

test_that("trakt.episodes.stats works", {
  trakt.episodes.stats("futurama", 1:2, 3:4) %>%
    expect_is("tbl") %>%
    expect_length(9) -> res

  res$season %>% expect_equal(c(1, 1, 2, 2))
  res$episode %>% expect_equal(c(3, 4, 3, 4))
})
