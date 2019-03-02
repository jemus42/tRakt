context("test-automated-lists")

test_that("trakt.popular works", {
  skip_on_cran()

  # movies
  pop_mov_min <- trakt.popular(type = "movies", limit = 5, extended = "min")
  pop_mov_max <- trakt.popular(type = "movies", limit = 5, extended = "full")

  expect_is(pop_mov_min, "tbl")
  expect_is(pop_mov_max, "tbl")

  expect_equal(nrow(pop_mov_min), 5)
  expect_equal(nrow(pop_mov_min), nrow(pop_mov_max))

  expect_error(trakt.popular(type = "movies", limit = -4))

  # shows
  pop_sho_min <- trakt.popular(type = "shows", limit = 5, extended = "min")
  pop_sho_max <- trakt.popular(type = "shows", limit = 5, extended = "full")

  expect_is(pop_sho_min, "tbl")
  expect_is(pop_sho_max, "tbl")

  expect_equal(nrow(pop_sho_min), 5)
  expect_equal(nrow(pop_sho_min), nrow(pop_sho_max))
})

test_that("trakt.trending works", {
  skip_on_cran()

  # movies
  tre_mov_min <- trakt.trending(type = "movies", limit = 5, extended = "min")
  tre_mov_max <- trakt.trending(type = "movies", limit = 5, extended = "full")

  expect_is(tre_mov_min, "tbl")
  expect_is(tre_mov_max, "tbl")

  expect_equal(nrow(tre_mov_min), 5)
  expect_equal(nrow(tre_mov_min), nrow(tre_mov_max))

  expect_error(trakt.trending(type = "movies", limit = -4))

  # shows
  tre_sho_min <- trakt.trending(type = "shows", limit = 5, extended = "min")
  tre_sho_max <- trakt.trending(type = "shows", limit = 5, extended = "full")

  expect_is(tre_sho_min, "tbl")
  expect_is(tre_sho_max, "tbl")

  expect_equal(nrow(tre_sho_min), 5)
  expect_equal(nrow(tre_sho_min), nrow(tre_sho_max))
})

test_that("trakt.anticipated works", {
  skip_on_cran()

  # movies
  tre_mov_min <- trakt.anticipated(type = "movies", limit = 5, extended = "min")
  tre_mov_max <- trakt.anticipated(type = "movies", limit = 5, extended = "full")

  expect_is(tre_mov_min, "tbl")
  expect_is(tre_mov_max, "tbl")

  expect_equal(nrow(tre_mov_min), 5)
  expect_equal(nrow(tre_mov_min), nrow(tre_mov_max))

  expect_error(trakt.anticipated(type = "movies", limit = -4))

  # shows
  tre_sho_min <- trakt.anticipated(type = "shows", limit = 5, extended = "min")
  tre_sho_max <- trakt.anticipated(type = "shows", limit = 5, extended = "full")

  expect_is(tre_sho_min, "tbl")
  expect_is(tre_sho_max, "tbl")

  expect_equal(nrow(tre_sho_min), 5)
  expect_equal(nrow(tre_sho_min), nrow(tre_sho_max))
})

test_that("trakt.played and trakt.watched also do things", {

  # Both have the same variables, the difference is just sorting
  nm <- c(
    "watcher_count", "play_count", "collected_count", "collector_count",
    "title", "year", "trakt", "slug", "tvdb", "imdb", "tmdb"
  )

  trakt.watched("shows", extended = "min", period = "weekly") %>%
    expect_is("tbl") %>%
    expect_length(11) %>%
    expect_named(nm) %>%
    nrow() %>%
    expect_equal(10)

  trakt.played("shows", extended = "min", period = "weekly") %>%
    expect_is("tbl") %>%
    expect_length(11) %>%
    expect_named(nm) %>%
    nrow() %>%
    expect_equal(10)
})
