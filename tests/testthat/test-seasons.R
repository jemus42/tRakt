context("test-seasons")

test_that("trakt.seasons.season works", {
  skip_on_cran()

  target <- "futurama"

  min_names <- c("season", "episode", "title", "trakt", "tvdb",
                 "imdb", "tmdb", "tvrage")

  min_s1_single <- trakt.seasons.season(target = target, seasons = 1, extended = "min")
  full_s1_single <- trakt.seasons.season(target = target, seasons = 1, extended = "full")

  # Structural integrity
  expect_is(min_s1_single, "tbl")
  expect_is(full_s1_single, "tbl")

  expect_named(min_s1_single, min_names)
  expect_equal(nrow(min_s1_single), nrow(full_s1_single))
  expect_equal(nrow(min_s1_single), 9)
  expect_lt(length(min_s1_single), length(full_s1_single))

  # Error conditions
  expect_error(trakt.seasons.season(target = target, seasons = NA))
  expect_error(trakt.seasons.season(target = target, seasons = "seven"))
  expect_error(trakt.seasons.season(target = target, seasons = NULL))
  expect_error(trakt.seasons.season(target = target, seasons = 10))

  # Multi-length input seasons
  expect_identical(
    rbind(trakt.seasons.season(target = target, seasons = 1),
          trakt.seasons.season(target = target, seasons = 2)),
    trakt.seasons.season(target = target, seasons = 1:2)
  )

})
