context("test-misc")

test_that("pad() pads", {
  expect_equal(
    pad(rep(1, 10), 1:10),
    c(
      "s01e01", "s01e02", "s01e03", "s01e04", "s01e05", "s01e06",
      "s01e07", "s01e08", "s01e09", "s01e10"
    )
  )
  expect_warning({
    x <- pad(1, 1:10)
  })
  expect_equal(x, character(10))
})

test_that("parse_trakt_url parses", {
  x <- parse_trakt_url("http://trakt.tv/show/fargo/season/1/episode/2",
    epid = TRUE, getslug = TRUE
  )
  expect_is(x, "list")
  expect_length(x, 3)

  x <- parse_trakt_url("http://trakt.tv/show/breaking-bad",
    epid = TRUE, getslug = FALSE
  )
  expect_named(x, c("show", "epid"))
  expect_equal(x$show, "breaking-bad")
  expect_equal(x$epid, NA)
})

test_that("build_trakt_url builds", {
  skip_on_cran()

  x <- build_trakt_url("shows", "breaking-bad", extended = "min", validate = TRUE)
  expect_is(x, "character")

  trakt_credentials()
  y <- trakt.api.call(x)
  expect_length(y, 3)
  expect_named(y, c("title", "year", "ids"))

  expect_error(build_trakt_url("3o2bkf", "qkfb23vf", validate = TRUE))
})

test_that("convert_datetime converts datetime", {
  skip_on_cran()
  skip_if_not_installed("lubridate")
  skip_if_not_installed("tibble")

  res <- tibble::tibble(updated_at = as.character(lubridate::now()))

  res <- tRakt:::convert_datetime(res)
  expect_is(res$updated_at, "POSIXct")
  expect_equal(attr(res$updated_at, "tzone"), "UTC")
  expect_error(tRakt:::convert_datetime("not_a_df_or_list"))
})

test_that("check_user is okay", {
  skip_on_cran()

  expect_error(tRakt:::check_username(user = NULL))
  expect_error(tRakt:::check_username(user = NA))
  expect_error(tRakt:::check_username(user = 4))
  expect_error(tRakt:::check_username(user = ""))
  expect_is(tRakt:::check_username(user = "jemus42", validate = TRUE), "list")
})
