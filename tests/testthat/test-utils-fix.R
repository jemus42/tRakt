test_that("fix_datetime converts datetime", {
  skip_if_not_installed("lubridate")

  res <- tibble::tibble(updated_at = as.character(lubridate::now()))

  res <- fix_datetime(res)
  expect_is(res$updated_at, "POSIXct")
  expect_equal(attr(res$updated_at, "tzone"), "UTC")
  expect_error(fix_datetime("not_a_df_or_list"))
})