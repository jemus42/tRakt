test_that("user_history does things", {
  skip_on_cran()

  user_history(user = "jemus42", "shows") |>
    expect_is("tbl") |>
    expect_length(18) |>
    nrow() |>
    expect_equal(10)

  user_history(user = "jemus42", "movies") |>
    expect_is("tbl") |>
    expect_length(10) |>
    nrow() |>
    expect_equal(10)

  user_history(user = c("jemus42", "sean"), limit = 2) |>
    expect_is("tbl") |>
    expect_length(19) |>
    nrow() |>
    expect_equal(4)
})
