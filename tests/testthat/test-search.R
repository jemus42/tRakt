context("test-search")

test_that("trakt.search works", {
  skip_on_cran()

  res <- trakt.search("russian doll", type = "show")
  res_y <- trakt.search("russian doll", type = "show", year = "2019")


  expect_is(res, "tbl")
  expect_equal(nrow(res), 1)
  expect_identical(res, res_y)

  res <- trakt.search("russian doll", type = "movie")
  expect_is(res, "tbl")
  expect_equal(nrow(res), 1)

  expect_warning(trakt.search("this is just a garbled mess", type = "movie"))
  expect_warning(trakt.search("deadpuul", type = "movie"))
})

test_that("trakt.search.byid works", {
  res <- trakt.search.byid(id = 614, id_type = "trakt-show")
  res2 <- trakt.search(query = "futurama", type = "show")

  expect_identical(res, res2)

  expect_error(trakt.search.byid(id = 1, id_type = "imdb"))
})
