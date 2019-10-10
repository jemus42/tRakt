test_that("pad_episode() pads", {
  expect_equal(
    pad_episode(rep(1, 10), 1:10),
    c(
      "s01e01", "s01e02", "s01e03", "s01e04", "s01e05", "s01e06",
      "s01e07", "s01e08", "s01e09", "s01e10"
    )
  )
  expect_warning(pad_episode(1, 1:10)) %>%
    expect_equal(character(10))
})

test_that("build_trakt_url builds a url", {
  x <- build_trakt_url("shows", "breaking-bad", extended = "min", validate = TRUE)
  expect_is(x, "character")

  y <- trakt_get(x)
  expect_length(y, 3)
  expect_named(y, c("title", "year", "ids"))

  expect_error(build_trakt_url("3o2bkf", "qkfb23vf", validate = TRUE))
})
