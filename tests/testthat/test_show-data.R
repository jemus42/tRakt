context("Show data")
skip_on_cran()

test_that("trakt.show.people returns data.frame", {
  expect_is(trakt.show.people(target = "game-of-thrones", extended = "min"), "data.frame")
  expect_is(trakt.show.people(target = "game-of-thrones", extended = "full"), "data.frame")
})

test_that("trakt.show.ratings returns data.frame", {
  expect_is(trakt.show.ratings(target = "game-of-thrones"), "list")
  expect_is(trakt.show.ratings(target = "game-of-thrones")$distribution, "data.frame")
})

test_that("trakt.show.season returns data.frame", {
  expect_is(trakt.show.season(target = "game-of-thrones", 1, extended = "min"), "data.frame")
  expect_is(trakt.show.season(target = "game-of-thrones", 2, extended = "full"), "data.frame")
})

test_that("trakt.show.summary returns list", {
  expect_is(trakt.show.summary(target = "game-of-thrones", extended = "min"), "list")
  expect_is(trakt.show.summary(target = "game-of-thrones", extended = "full"), "list")
})

#### Test the summary functions ####
context("Show summary functions")

test_that("trakt.getSeasons returns data.frame", {
  expect_is(trakt.getSeasons(target = "game-of-thrones", extended = "min"), "data.frame")
  expect_is(trakt.getSeasons(target = "game-of-thrones", extended = "full"), "data.frame")
  expect_is(trakt.getSeasons(target = "game-of-thrones", extended = "full,images"), "data.frame")
})

test_that("trakt.getEpisodeData returns data.frame", {
  expect_is(trakt.getEpisodeData(target = "game-of-thrones", c(1,2,3),
                                 extended = "min"), "data.frame")
  expect_is(trakt.getEpisodeData(target = "game-of-thrones", c(1,2,3),
                                 extended = "full"), "data.frame")
  expect_is(trakt.getEpisodeData(target = "game-of-thrones", c(1,2,3),
                                 extended = "full,images"), "data.frame")
})

test_that("trakt.getFullShowData returns properly structured list", {
  show <- trakt.getFullShowData("Breaking Bad")
  expect_is(show, "list")
  expect_is(show$info, "data.frame")
  expect_is(show$summary, "list")
  expect_is(show$seasons, "data.frame")
  expect_is(show$episodes, "data.frame")
})
