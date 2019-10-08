context("Utils")

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

test_that("fix_datetime converts datetime", {
  skip_if_not_installed("lubridate")

  res <- tibble::tibble(updated_at = as.character(lubridate::now()))

  res <- fix_datetime(res)
  expect_is(res$updated_at, "POSIXct")
  expect_equal(attr(res$updated_at, "tzone"), "UTC")
  expect_error(fix_datetime("not_a_df_or_list"))
})

test_that("check_user throws errors when it should", {
  skip_on_cran()

  expect_error(check_username(user = NULL))
  expect_error(check_username(user = NA))
  expect_error(check_username(user = 4))
  expect_error(check_username(user = ""))
  expect_failure(expect_error(
    check_username(user = "jemus42", validate = TRUE), "list"
  ))
})

test_that("check_filter_arg fails how it should", {
  expect_null(check_filter_arg(NULL))

  expect_warning(check_filter_arg(10239, "years"))
  expect_warning(check_filter_arg(11, "ratings"))
  expect_warning(check_filter_arg(1:5, "runtimes"))
  expect_warning(check_filter_arg("five", "genres"))
  expect_warning(check_filter_arg("five", "networks"))
  expect_warning(check_filter_arg("five", "languages"))
  expect_warning(check_filter_arg("five", "certifications"))
  expect_warning(check_filter_arg("five", "countries"))
  expect_warning(check_filter_arg("five", "status"))

  expect_equal(
    check_filter_arg(c("action", "drama"), filter_type = "genres"),
    "action,drama"
  )
  expect_equal(
    check_filter_arg(c("HBO", "TNT"), filter_type = "networks"),
    "HBO,TNT"
  )
  expect_equal(
    check_filter_arg(c("en", "de"), filter_type = "languages"),
    "en,de"
  )
  expect_equal(
    check_filter_arg(c("pg-13", "r"), filter_type = "certifications"),
    "pg-13,r"
  )
  expect_equal(
    check_filter_arg(c("ar", "am"), filter_type = "countries"),
    "ar,am"
  )
  expect_equal(
    check_filter_arg(c("ended", "canceled"), filter_type = "status"),
    "ended,canceled"
  )
})
