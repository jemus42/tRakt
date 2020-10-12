test_that("people_summary works", {
  skip_on_cran()

  id <- "bryan-cranston"

  people_min <- people_summary(id = id, extended = "min")
  people_max <- people_summary(id = id, extended = "full")

  expect_is(people_min, "tbl")
  expect_equal(nrow(people_min), 1)
  expect_equal(ncol(people_min), 5)
  expect_is(people_max, "tbl")
  expect_equal(ncol(people_max), 11)

  expect_identical(
    rbind(
      people_summary(id = id),
      people_summary(id = id)
    ),
    people_summary(id = c(id, id))
  )
})

test_that("people_media works", {
  skip_on_cran()

  id <- "bryan-cranston"

  mov_min <- people_movies(id = id, extended = "min")
  mov_max <- people_movies(id = id, extended = "full")

  expect_is(mov_min, "list")
  expect_named(mov_min, c("cast", "crew"))
  expect_is(mov_min$cast, "tbl")
  expect_is(mov_min$crew, "tbl")

  sho_min <- people_shows(id = id, extended = "min")
  sho_max <- people_shows(id = id, extended = "full")

  expect_is(sho_min, "list")
  expect_named(sho_min, c("cast", "crew"))
  expect_is(sho_min$cast, "tbl")
  expect_is(sho_min$crew, "tbl")
})
