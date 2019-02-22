context("test-user-collection")

test_that("trakt.user.collection works", {
  skip_on_cran()
  
  user <- "jemus42"

  col_sho <- trakt.user.collection(user = user, type = "shows", unnest_episodes = FALSE)
  col_mov <- trakt.user.collection(user = user, type = "movies")
  col_sho2 <- trakt.user.collection(user = user)

  expect_identical(col_sho, col_sho2)

  # Error conditions ----
  expect_error(trakt.user.collection(user = -1))
  expect_error(trakt.user.collection(user = user, type = "wurst"))
})

# The unnesting thing ----

test_that("trakt.user.collection works with episode unnesting", {
  skip_if_not_installed("tidyr")
  skip_on_cran()

  user <- "jemus42"
  col_eps <- trakt.user.collection(user = user, type = "shows", unnest_episodes = TRUE)

  expect_is(col_eps, "tbl")
  expect_equal(ncol(col_eps), 13)
  expect_gt(nrow(col_eps), 10)
  expect_is(col_eps$collected_at, "POSIXct")
})
