context("Show data")

sample_show <- "game-of-thrones"
multi_show  <- c("game-of-thrones", "breaking-bad")

test_that("trakt.show.people returns list", {
  expect_is(trakt.show.people(target = sample_show, extended = "min"), "list")
  expect_is(trakt.show.people(target = sample_show, extended = "full"), "list")
})

test_that("trakt.show.ratings returns data.frame", {
  ratings <- trakt.show.ratings(target = sample_show)
  expect_is(ratings, "data.frame")
  expect_is(ratings$distribution, "data.frame")
})

test_that("trakt.show.ratings returns correct structures on multiple inputs", {
  ratings <- trakt.show.ratings(target = multi_show)
  expect_is(ratings, "list")
  expect_is(ratings$`game-of-thrones`, "list")
  expect_is(ratings[[1]][[1]], "data.frame")
  expect_is(ratings[[1]][[2]], "data.frame")
})

test_that("trakt.seasons.season returns data.frame", {
  expect_is(trakt.seasons.season(target = sample_show, 1, extended = "min"), "data.frame")
  expect_is(trakt.seasons.season(target = sample_show, 2, extended = "full"), "data.frame")
  expect_is(trakt.seasons.season(target = sample_show, 1:2, extended = "min"), "data.frame")
})

test_that("trakt.show.summary returns correct structure", {
  expect_is(trakt.show.summary(target = sample_show, extended = "min"), "list")
  expect_is(trakt.show.summary(target = sample_show, extended = "full"), "list")
  expect_is(trakt.show.summary(target = sample_show,
                               extended = "min", force_data_frame = TRUE), "data.frame")
  expect_is(trakt.show.summary(target = sample_show,
                               extended = "full", force_data_frame = TRUE), "data.frame")
  expect_is(trakt.show.summary(target = sample_show,
                               extended = "full,images", force_data_frame = TRUE), "data.frame")
  expect_is(trakt.show.summary(target = multi_show, extended = "min"), "data.frame")
})

test_that("trakt.show.watching returns returns correct structure", {
  watching <- trakt.show.watching(sample_show, extended = "min")
  if (!is.null(watching)){
    expect_is(watching, "data.frame")
  }
  watching <- trakt.show.watching(sample_show, extended = "full")
  if (!is.null(watching)){
    expect_is(watching, "data.frame")
    expect_is(watching$joined_at, "POSIXct")
  }
  watching <- trakt.show.watching(multi_show, extended = "min")
  if (!is.null(watching)){
    expect_is(watching, "data.frame")
  }
})

test_that("trakt.seasons.summary returns data.frame", {
  expect_is(trakt.seasons.summary(target = sample_show, extended = "min"), "data.frame")
  expect_is(trakt.seasons.summary(target = sample_show, extended = "full"), "data.frame")
  expect_is(trakt.seasons.summary(target = sample_show, extended = "full,images"), "data.frame")
  expect_is(trakt.seasons.summary(target = multi_show,  extended = "min"), "data.frame")
})

#### Test the summary functions ####
context("Show summary functions")

test_that("trakt.get_all_episodes returns data.frame", {
  expect_is(trakt.get_all_episodes(target = sample_show, c(1,2,3), extended = "min"), "data.frame")
  expect_is(trakt.get_all_episodes(target = sample_show, 3,        extended = "full"), "data.frame")
  expect_is(trakt.get_all_episodes(target = sample_show,           extended = "full,images"), "data.frame")
})

test_that("trakt.get_full_showdata returns properly structured list", {
  show <- trakt.get_full_showdata("Breaking Bad")
  expect_is(show,          "list")
  expect_is(show$info,     "data.frame")
  expect_is(show$summary,  "list")
  expect_is(show$seasons,  "data.frame")
  expect_is(show$episodes, "data.frame")
})
