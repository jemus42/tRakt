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
