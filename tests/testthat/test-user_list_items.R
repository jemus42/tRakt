test_that("user_list_items are correct", {
  skip_on_cran()

  # Can't think of anything better than reference cases :/
  user_list_items(
    user = "jemus42",
    list_id = 2171659,
    extended = "min"
  ) |>
    expect_is("tbl_df") |>
    expect_length(19)

  user_list_items(
    user = "jemus42",
    list_id = 2171659,
    extended = "full"
  ) |>
    expect_is("tbl_df") |>
    expect_length(52)

  user_list_items(
    user = "sp1ti",
    list_id = "anime-winter-season-2018-2019",
    extended = "min"
  ) |>
    expect_is("tbl_df") |>
    expect_length(23)

  user_list_items(
    user = "sp1ti",
    list_id = "anime-winter-season-2018-2019",
    extended = "full"
  ) |>
    expect_is("tbl_df") |>
    expect_length(65)
})
