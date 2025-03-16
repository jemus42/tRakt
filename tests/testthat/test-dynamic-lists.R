test_that("popular_media works", {
  skip_on_cran()

  # movies
  pop_mov_min <- movies_popular(limit = 5, extended = "min")
  pop_mov_max <- movies_popular(limit = 5, extended = "full")

  expect_s3_class(pop_mov_min, "tbl")
  expect_s3_class(pop_mov_max, "tbl")

  expect_equal(nrow(pop_mov_min), 5)
  expect_equal(nrow(pop_mov_min), nrow(pop_mov_max))

  expect_error(movies_popular(limit = -4))

  # shows
  pop_sho_min <- shows_popular(limit = 5, extended = "min")
  pop_sho_max <- shows_popular(limit = 5, extended = "full")

  expect_s3_class(pop_sho_min, "tbl")
  expect_s3_class(pop_sho_max, "tbl")

  expect_equal(nrow(pop_sho_min), 5)
  expect_equal(nrow(pop_sho_min), nrow(pop_sho_max))
})

test_that("trending_media works", {
  skip_on_cran()

  # movies
  tre_mov_min <- movies_trending(limit = 5, extended = "min")
  tre_mov_max <- movies_trending(limit = 5, extended = "full")

  expect_s3_class(tre_mov_min, "tbl")
  expect_s3_class(tre_mov_max, "tbl")

  expect_equal(nrow(tre_mov_min), 5)
  expect_equal(nrow(tre_mov_min), nrow(tre_mov_max))

  expect_error(movies_trending(limit = -4))

  # shows
  tre_sho_min <- shows_trending(limit = 5, extended = "min")
  tre_sho_max <- shows_trending(limit = 5, extended = "full")

  expect_s3_class(tre_sho_min, "tbl")
  expect_s3_class(tre_sho_max, "tbl")

  expect_equal(nrow(tre_sho_min), 5)
  expect_equal(nrow(tre_sho_min), nrow(tre_sho_max))
})

test_that("anticipated_media works", {
  skip_on_cran()

  # movies
  tre_mov_min <- movies_anticipated(limit = 5, extended = "min")
  tre_mov_max <- movies_anticipated(limit = 5, extended = "full")

  expect_s3_class(tre_mov_min, "tbl")
  expect_s3_class(tre_mov_max, "tbl")

  expect_equal(nrow(tre_mov_min), 5)
  expect_equal(nrow(tre_mov_min), nrow(tre_mov_max))

  expect_error(movies_anticipated(limit = -4))

  # shows
  tre_sho_min <- shows_anticipated(limit = 5, extended = "min")
  tre_sho_max <- shows_anticipated(limit = 5, extended = "full")

  expect_s3_class(tre_sho_min, "tbl")
  expect_s3_class(tre_sho_max, "tbl")

  expect_equal(nrow(tre_sho_min), 5)
  expect_equal(nrow(tre_sho_min), nrow(tre_sho_max))
})

test_that("played_media and watched_media also do things", {
  # Both have the same variables, the difference is just sorting
  nm_shows <- c(
    "watcher_count",
    "play_count",
    "collected_count",
    "collector_count",
    "title",
    "year",
    "trakt",
    "slug",
    "tvdb",
    "imdb",
    "tmdb"
  )

  nm_movies <- c(
    "watcher_count",
    "play_count",
    "collected_count",
    "title",
    "year",
    "trakt",
    "slug",
    "imdb",
    "tmdb"
  )

  shows_watched(extended = "min", period = "weekly") |>
    expect_s3_class("tbl") |>
    expect_named(nm_shows) |>
    nrow() |>
    expect_equal(10)

  movies_watched(extended = "min", period = "weekly") |>
    expect_s3_class("tbl") |>
    expect_named(nm_movies) |>
    nrow() |>
    expect_equal(10)

  shows_played(extended = "min", period = "weekly") |>
    expect_s3_class("tbl") |>
    expect_named(nm_shows) |>
    nrow() |>
    expect_equal(10)

  movies_played(extended = "min", period = "weekly") |>
    expect_s3_class("tbl") |>
    expect_named(nm_movies) |>
    nrow() |>
    expect_equal(10)
})

test_that("collected_media does its thing", {
  shows_collected(limit = 5) |>
    expect_s3_class("tbl") |>
    expect_length(11) |>
    nrow() |>
    expect_equal(5)

  movies_collected(limit = 5) |>
    expect_s3_class("tbl") |>
    expect_length(9) |>
    nrow() |>
    expect_equal(5)
})
#
# test_that("updated_media works", {
#   shows_updates() |>
#     expect_s3_class("tbl") |>
#     expect_length(8) |>
#     nrow() |>
#     expect_equal(10)
#
#   movies_updates() |>
#     expect_s3_class("tbl") |>
#     expect_length(7) |>
#     nrow() |>
#     expect_equal(10)
# })
