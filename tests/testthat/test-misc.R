context("test-misc")

test_that("pad() pads", {
  expect_equal(
    pad(rep(1, 10), 1:10),
    c("s01e01", "s01e02", "s01e03", "s01e04", "s01e05", "s01e06",
      "s01e07", "s01e08", "s01e09", "s01e10")
  )
  expect_warning({x <- pad(1, 1:10)})
  expect_equal(x, character(10))
})

test_that("parse_trakt_url parses", {
  x <- parse_trakt_url("http://trakt.tv/show/fargo/season/1/episode/2",
                       epid = TRUE, getslug = TRUE)
  expect_is(x, "list")
  expect_length(x, 3)

  x <- parse_trakt_url("http://trakt.tv/show/breaking-bad",
                       epid = TRUE, getslug = FALSE)
  expect_named(x, c("show", "epid"))
  expect_equal(x$show, "breaking-bad")
  expect_equal(x$epid, NA)
})

test_that("build_trakt_url builds", {
  x <- build_trakt_url("shows", "breaking-bad", extended = "min")
  expect_is(x, "character")

  get_trakt_credentials()
  y <- trakt.api.call(x)
  expect_length(y, 3)
  expect_named(y, c("title", "year", "ids"))
})
