context("test-people-methods")

test_that("trakt.people.summary works", {
  skip_on_cran()

  target <- "bryan-cranston"

  people_min <- trakt.people.summary(target = target, extended = "min")
  people_max <- trakt.people.summary(target = target, extended = "full")

  expect_is(people_min, "tbl")
  expect_equal(nrow(people_min), 1)
  expect_equal(ncol(people_min), 5)
  expect_is(people_max, "tbl")
  expect_equal(nrow(people_max), 1)
  expect_equal(ncol(people_max), 10)

  expect_identical(
    rbind(
      trakt.people.summary(target = target),
      trakt.people.summary(target = target)
    ),
    trakt.people.summary(target = c(target, target))
  )
})

test_that("trakt.people.[movies|shows] works", {
  skip_on_cran()

  target <- "bryan-cranston"

  mov_min <- trakt.people.movies(target = target, extended = "min")
  mov_max <- trakt.people.movies(target = target, extended = "full")

  expect_is(mov_min, "list")
  expect_named(mov_min, c("cast", "crew"))
  expect_is(mov_min$cast, "tbl")
  expect_is(mov_min$crew, "tbl")

  sho_min <- trakt.people.shows(target = target, extended = "min")
  sho_max <- trakt.people.shows(target = target, extended = "full")

  expect_is(sho_min, "list")
  expect_named(sho_min, c("cast", "crew"))
  expect_is(sho_min$cast, "tbl")
  expect_is(sho_min$crew, "tbl")
})


test_that("trakt.[show|movie].people works", {
  skip_on_cran()

  target_mov <- "inception-2010"
  target_sho <- "futurama"

  show_people <- trakt.shows.people(target = target_sho)
  movie_people <- trakt.movies.people(target = target_mov)

  expect_is(show_people, "list")
  expect_is(movie_people, "list")

  expect_equal(names(show_people), names(movie_people))
  expect_named(show_people, c("cast", "crew"))
  expect_named(movie_people, c("cast", "crew"))
})
