context("test-search")

test_that("trakt.search works", {
  skip_on_cran()

  res <- trakt.search("russian doll", type = "show")

  expect_is(res, "tbl")
  expect_equal(nrow(res), 1)

  res <- trakt.search("russian doll", type = "movie")
  expect_is(res, "tbl")
  expect_equal(nrow(res), 1)

  expect_warning(trakt.search("this is just a garbled mess", type = "movie"))
  expect_warning(trakt.search("deadpuul", type = "movie"))
})

test_that("trakt.search.byid works", {
  id <- 614 # Futurama

  res <- trakt.search.byid(id = id, id_type = "trakt-show")
  res2 <- trakt.search(query = "futurama", type = "show")

  expect_identical(res, res2)

  expect_error(trakt.search.byid(id = 1, id_type = "imdb"))
})
