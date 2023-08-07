test_that("seasons_season works", {
  skip_on_cran()

  id <- "futurama"

  min_names <- c(
    "season", "episode", "title", "trakt", "tvdb",
    "imdb", "tmdb"
  )

  min_s1_single <- seasons_season(id = id, seasons = 1, extended = "min")
  full_s1_single <- seasons_season(id = id, seasons = 1, extended = "full")

  # Structural integrity
  expect_is(min_s1_single, "tbl")
  expect_is(full_s1_single, "tbl")

  expect_named(min_s1_single, min_names)
  expect_equal(nrow(min_s1_single), nrow(full_s1_single))
  expect_equal(nrow(min_s1_single), 9)
  expect_lt(length(min_s1_single), length(full_s1_single))

  # Error conditions
  expect_error(seasons_season(id = id, seasons = NA))
  expect_error(seasons_season(id = id, seasons = "seven"))
  expect_error(seasons_season(id = id, seasons = NULL))
  expect_message(seasons_season(id = id, seasons = 10))

  # Multi-length input seasons
  expect_identical(
    rbind(
      seasons_season(id = id, seasons = 1),
      seasons_season(id = id, seasons = 2)
    ),
    seasons_season(id = id, seasons = 1:2)
  )
})

test_that("seasons_summary works", {
  skip_on_cran()

  id <- "breaking-bad"

  # Note that dropping unaired only workes if extended = full so this is weird
  result_min <- seasons_summary(
    id = id, extended = "min",
    drop_specials = TRUE, drop_unaired = TRUE
  )
  result_max <- seasons_summary(
    id = id, extended = "full",
    drop_specials = TRUE, drop_unaired = TRUE
  )

  expect_is(result_min, "tbl")
  expect_is(result_max, "tbl")
  expect_equal(ncol(result_min), 4)
  expect_equal(ncol(result_max), 13)

  expect_lt(length(result_min), length(result_max))
  expect_equal(nrow(result_min), nrow(result_max))

  expect_identical(
    rbind(
      seasons_summary(id),
      seasons_summary(id)
    ),
    seasons_summary(c(id, id))
  )

  expect_message(seasons_summary(id = "bvkjqbkqjbf"))
})

test_that("seasons_summary works for episodes and matches seasons_season", {
  skip_on_cran()

  id <- "utopia"
  res <- seasons_summary(id, extended = "full", episodes = TRUE)

  expect_is(res, "tbl")
  expect_is(res$episodes, "list")
  expect_length(res$episodes, 2)

  res$episodes[[1]] |>
    expect_is("tbl") |>
    expect_length(16) |>
    nrow() |>
    expect_equal(6)

  expect_identical(
    res$episodes[[1]],
    seasons_season(id, seasons = 1, extended = "full")
  )
})
