context("People methods")

test_that("people_summary works", {
  skip_on_cran()

  target <- "bryan-cranston"

  people_min <- people_summary(target = target, extended = "min")
  people_max <- people_summary(target = target, extended = "full")

  expect_is(people_min, "tbl")
  expect_equal(nrow(people_min), 1)
  expect_equal(ncol(people_min), 5)
  expect_is(people_max, "tbl")
  expect_equal(nrow(people_max), 1)
  expect_equal(ncol(people_max), 10)

  expect_identical(
    rbind(
      people_summary(target = target),
      people_summary(target = target)
    ),
    people_summary(target = c(target, target))
  )
})

test_that("people_media works", {
  skip_on_cran()

  target <- "bryan-cranston"

  mov_min <- people_movies(target = target, extended = "min")
  mov_max <- people_movies(target = target, extended = "full")

  expect_is(mov_min, "list")
  expect_named(mov_min, c("cast", "crew"))
  expect_is(mov_min$cast, "tbl")
  expect_is(mov_min$crew, "tbl")

  sho_min <- people_shows(target = target, extended = "min")
  sho_max <- people_shows(target = target, extended = "full")

  expect_is(sho_min, "list")
  expect_named(sho_min, c("cast", "crew"))
  expect_is(sho_min$cast, "tbl")
  expect_is(sho_min$crew, "tbl")
})


test_that("media_people works", {
  skip_on_cran()

  target_mov <- "inception-2010"
  target_sho <- "futurama"

  show_people <- shows_people(target = target_sho)
  movie_people <- movies_people(target = target_mov)

  expect_is(show_people, "list")
  expect_is(movie_people, "list")

  expect_equal(names(show_people), names(movie_people))
  expect_named(show_people, c("cast", "crew"))
  expect_named(movie_people, c("cast", "crew"))
})
