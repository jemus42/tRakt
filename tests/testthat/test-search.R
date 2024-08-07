test_that("search_query works", {
  skip_on_cran()

  res <- search_query("russian doll 2019", type = "show")
  # res <- search_query("russian doll", type = "show", years = "2019")


  expect_is(res, "tbl")
  expect_equal(nrow(res), 1)

  res <- search_query("russian doll", type = "movie")
  expect_is(res, "tbl")
  expect_equal(nrow(res), 1)

  expect_warning(search_query("deadpuul", type = "movie"))
  expect_warning(search_query("nfkwjbevkwbvkwvbqlwfbqwkjfbqkjfb", type = "movie", years = 1100))


  search_query("russian doll", type = c("show", "movie")) |>
    expect_is("tbl_df") |>
    expect_length(9) |>
    nrow() |>
    expect_equal(2)
})

test_that("search_id works", {
  skip_on_cran()

  # Oddly enough, 614 matches Home Alone oO
  res <- search_id(id = 614, id_type = "trakt", type = "show")
  res2 <- search_query(query = "futurama", type = "show")

  expect_identical(res$title, res2$title)

  expect_warning(search_id(id = 1, id_type = "imdb"))
  expect_warning(search_id(
    id = "nfkwjbevkwbvkwvbqlwfbqwkjfbqkjfb",
    id_type = "trakt"
  ))
})
