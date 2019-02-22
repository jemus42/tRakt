context("test-user-friendfollow")

test_that("trakt.user.followers works", {
  skip_on_cran()

  user <- "jemus42"

  fol_min <- trakt.user.followers(user = "jemus42", extended = "min")
  fol_max <- trakt.user.followers(user = "jemus42", extended = "full")

  expect_is(fol_min, "tbl")
  expect_is(fol_max, "tbl")
  expect_gt(ncol(fol_max), ncol(fol_min))

  expect_identical(
    rbind(
      trakt.user.followers(user = user),
      trakt.user.followers(user = user)
    ),
    trakt.user.followers(user = c(user, user))
  )

  # Error conditions
  expect_error(trakt.user.followers(user = ""))
  expect_error(trakt.user.followers(user = NA))
  expect_error(trakt.user.followers(user = 4))
})

test_that("trakt.user.following works", {
  skip_on_cran()

  user <- "jemus42"

  fol_min <- trakt.user.following(user = "jemus42", extended = "min")
  fol_max <- trakt.user.following(user = "jemus42", extended = "full")

  expect_is(fol_min, "tbl")
  expect_is(fol_max, "tbl")
  expect_gt(ncol(fol_max), ncol(fol_min))

  expect_identical(
    rbind(
      trakt.user.following(user = user),
      trakt.user.following(user = user)
    ),
    trakt.user.following(user = c(user, user))
  )

  # Error conditions
  expect_error(trakt.user.following(user = ""))
  expect_error(trakt.user.following(user = NA))
  expect_error(trakt.user.following(user = 4))
})

test_that("trakt.user.friends works", {
  skip_on_cran()

  user <- "jemus42"

  fol_min <- trakt.user.friends(user = "jemus42", extended = "min")
  fol_max <- trakt.user.friends(user = "jemus42", extended = "full")

  expect_is(fol_min, "tbl")
  expect_is(fol_max, "tbl")
  expect_gt(ncol(fol_max), ncol(fol_min))

  expect_identical(
    rbind(
      trakt.user.friends(user = user),
      trakt.user.friends(user = user)
    ),
    trakt.user.friends(user = c(user, user))
  )

  # Error conditions
  expect_error(trakt.user.friends(user = ""))
  expect_error(trakt.user.friends(user = NA))
  expect_error(trakt.user.friends(user = 4))
})
