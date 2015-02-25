context("Search functions")

test_that("search returns list for both show and movie query", {
  expect_is(trakt.search("Breaking Bad", type = "show"), "data.frame")
  expect_is(trakt.search("TRON", type = "movie"), "data.frame")
})

test_that("search by keyword and search by id return identical results", {
  expect_identical(trakt.search("Breaking Bad"), trakt.search.byid("tt0903747", id_type = "imdb"))
})

test_that("nonsense search query returns warning (not error)", {
  expect_warning(trakt.search("293t923gbf92hf02323g"))
})
