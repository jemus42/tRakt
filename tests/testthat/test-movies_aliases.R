test_that("aliases work", {
  movies_aliases(190430) |>
    expect_is("tbl_df") |>
    expect_length(2) |>
    expect_named(c("title", "country"))

  shows_aliases(104439) |>
    expect_is("tbl_df") |>
    expect_length(2) |>
    expect_named(c("title", "country"))
})
