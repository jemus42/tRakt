context("test-user-ratings")

test_that("trakt.user.ratings works", {
  skip_on_cran()
  user <- "jemus42"

  rat_shows <- trakt.user.ratings(user = user, type = "shows")
  rat_episo <- trakt.user.ratings(user = user, type = "episodes")
  rat_movie <- trakt.user.ratings(user = user, type = "movies")

  expect_named(rat_shows, c("rated_at", "rating", "type", "title", "year", "trakt", "slug",
                            "tvdb", "imdb", "tmdb", "tvrage"))

  expect_named(rat_episo, c("rated_at", "rating", "type", "season", "episode", "title",
                            "episode.trakt", "episode.tvdb", "episode.imdb", "episode.tmdb",
                            "episode.tvrage", "show.title", "show.year", "show.trakt", "show.slug",
                            "show.tvdb", "show.imdb", "show.tmdb", "show.tvrage"))

  expect_named(rat_movie, c("rated_at", "rating", "type", "title", "year", "trakt", "slug",
                            "imdb", "tmdb"))

  expect_is(rat_shows, "tbl")
  expect_is(rat_episo, "tbl")
  expect_is(rat_movie, "tbl")

  # Error conditions ----
  expect_error(trakt.user.ratings(user = -1))
  expect_error(trakt.user.ratings(user = user, type = "seven"))
})
