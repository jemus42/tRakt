context("Search functions")

test_that("search returns data.frame for both show and movie query", {
  expect_is(trakt.search("Breaking Bad", type = "show"), "data.frame")
  expect_is(trakt.search("TRON", type = "movie"), "data.frame")
})

test_that("search can actually find Doctor Who 2005", {
  show <- trakt.search("Doctor Who 2005")
  expect_equal(show$ids$slug, "doctor-who-2005")
  expect_identical(trakt.search("Doctor Who 2005"), trakt.search("Doctor Who", year = "2005"))
})

test_that("search by keyword and search by id return identical results", {
  expect_identical(trakt.search("House of Cards 2013"),
                   trakt.search.byid("tt1856010", id_type = "imdb"))
  expect_identical(trakt.search("Tron: Legacy", type = "movie"),
                   trakt.search.byid("tt1104001", id_type = "imdb"))
})

test_that("nonsense search query returns warning (not error)", {
  expect_warning(trakt.search("293t923gbf92hf02323g"))
})
