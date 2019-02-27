context("test-user-friendfollow")

test_that("trakt.user.network works", {
  skip_on_cran()

  user <- "jemus42"

  fol_min <- trakt.user.network(relationship = "followers", user = "jemus42", extended = "min")
  fol_max <- trakt.user.network(relationship = "followers", user = "jemus42", extended = "full")

  expect_is(fol_min, "tbl")
  expect_is(fol_max, "tbl")
  expect_gt(ncol(fol_max), ncol(fol_min))

  expect_identical(
    rbind(
      trakt.user.network(relationship = "followers", user = user),
      trakt.user.network(relationship = "followers", user = user)
    ),
    trakt.user.network(relationship = "followers", user = c(user, user))
  )

  # Error conditions
  expect_error(trakt.user.network(user = ""))
  expect_error(trakt.user.network(user = NA))
  expect_error(trakt.user.network(user = 4))
})
