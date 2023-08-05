test_that("user_stats works", {
  skip_on_cran()

  user <- "jemus42"

  userstats <- user_stats(user = user)

  expect_is(userstats, "list")
  expect_named(userstats, c(
    "movies", "shows", "seasons", "episodes",
    "network", "ratings"
  ))

  userstats <- user_stats(user = c(user, "sean"))
  expect_is(userstats, "list")
  expect_named(userstats, c(user, "sean"))
  expect_named(userstats[[user]], c(
    "movies", "shows", "seasons", "episodes",
    "network", "ratings"
  ))
})

test_that("media_stats does things", {
  skip_on_cran()

  shows_stats(id = "futurama") %>%
    expect_is("tbl") %>%
    expect_length(11) %>%
    nrow() %>%
    expect_equal(1)


  stats_mov <- movies_stats(id = "deadpool-2016") %>%
    expect_is("tbl") %>%
    expect_length(10) %>%
    nrow() %>%
    expect_equal(1)

  stats_multi <- shows_stats(id = c("futurama", "breaking-bad"))
  expect_equal(nrow(stats_multi), 2)
})

test_that("seasons_stats works", {
  seasons_stats("futurama", 1:2) %>%
    expect_is("tbl") %>%
    expect_length(9) -> res

  res$season %>% expect_equal(1:2)
})

test_that("episodes_stats works", {
  episodes_stats("futurama", 1:2, 3:4) %>%
    expect_is("tbl") %>%
    expect_length(9) -> res

  res$season %>% expect_equal(c(1, 1, 2, 2))
  res$episode %>% expect_equal(c(3, 4, 3, 4))
})
