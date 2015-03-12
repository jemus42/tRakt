context("People data")

sample_person <- "peter-dinklage"
multi_person  <- c("peter-dinklage", "maisie-williams")

test_that("trakt.people.summary returns data.frame", {
  expect_is(trakt.people.summary(target = sample_person, extended = "min"), "data.frame")
  expect_is(trakt.people.summary(target = sample_person, extended = "full"), "data.frame")
  expect_is(trakt.people.summary(target = multi_person,  extended = "min"), "data.frame")
})

test_that("trakt.people.movies returns data.frame", {
  people.movies.min <- trakt.people.movies(target = sample_person, extended = "min")
  expect_is(people.movies.min,      "list")
  expect_is(people.movies.min$cast, "data.frame")

  people.movies.full <- trakt.people.movies(target = sample_person, extended = "full")
  expect_is(people.movies.full,      "list")
  expect_is(people.movies.full$cast, "data.frame")
})

test_that("trakt.people.shows returns data.frame", {
  people.shows.min <- trakt.people.shows(target = sample_person, extended = "min")
  expect_is(people.shows.min,      "list")
  expect_is(people.shows.min$cast, "data.frame")

  people.shows.full <- trakt.people.shows(target = sample_person, extended = "full")
  expect_is(people.shows.full,      "list")
  expect_is(people.shows.full$cast, "data.frame")
})
