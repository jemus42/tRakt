context("test-popular-trending-et-al")

test_that("trakt.popular works", {
  skip_on_cran()
  
  # movies
  pop_mov_min <- trakt.movies.popular(limit = 5, page = 1, extended = "min")
  pop_mov_max <- trakt.movies.popular(limit = 5, page = 1, extended = "full")

  expect_is(pop_mov_min, "tbl")
  expect_is(pop_mov_max, "tbl")
  expect_gt(ncol(pop_mov_max), ncol(pop_mov_min))

  expect_equal(nrow(pop_mov_min), 5)
  expect_equal(nrow(pop_mov_min), nrow(pop_mov_max))

  expect_error(trakt.movies.popular(limit = -4))
  expect_error(trakt.movies.popular(page = 0))

  # shows
  pop_sho_min <- trakt.shows.popular(limit = 5, page = 1, extended = "min")
  pop_sho_max <- trakt.shows.popular(limit = 5, page = 1, extended = "full")

  expect_is(pop_sho_min, "tbl")
  expect_is(pop_sho_max, "tbl")
  expect_gt(ncol(pop_sho_max), ncol(pop_sho_min))

  expect_equal(nrow(pop_sho_min), 5)
  expect_equal(nrow(pop_sho_min), nrow(pop_sho_max))
})

test_that("trakt.trending works", {
  skip_on_cran()
  
  # movies
  tre_mov_min <- trakt.movies.trending(limit = 5, page = 1, extended = "min")
  tre_mov_max <- trakt.movies.trending(limit = 5, page = 1, extended = "full")

  expect_is(tre_mov_min, "tbl")
  expect_is(tre_mov_max, "tbl")
  expect_gt(ncol(tre_mov_max), ncol(tre_mov_min))

  expect_equal(nrow(tre_mov_min), 5)
  expect_equal(nrow(tre_mov_min), nrow(tre_mov_max))

  expect_error(trakt.movies.trending(limit = -4))
  expect_error(trakt.movies.trending(page = 0))

  # shows
  tre_sho_min <- trakt.shows.trending(limit = 5, page = 1, extended = "min")
  tre_sho_max <- trakt.shows.trending(limit = 5, page = 1, extended = "full")

  expect_is(tre_sho_min, "tbl")
  expect_is(tre_sho_max, "tbl")
  expect_gt(ncol(tre_sho_max), ncol(tre_sho_min))

  expect_equal(nrow(tre_sho_min), 5)
  expect_equal(nrow(tre_sho_min), nrow(tre_sho_max))
})
