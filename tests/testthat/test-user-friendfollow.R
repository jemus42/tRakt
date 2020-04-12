test_that("user_network stuff works", {
  skip_on_cran()

  user <- "jemus42"

  fol_min <- user_followers(user = user, extended = "min")
  fol_max <- user_followers(user = user, extended = "full")

  expect_is(fol_min, "tbl")
  expect_is(fol_max, "tbl")
  expect_gt(ncol(fol_max), ncol(fol_min))

  expect_identical(
    rbind(
      user_followers(user = user),
      user_followers(user = user)
    ),
    user_followers(user = c(user, user))
  )

  # Error conditions
  expect_error(user_followers(user = ""))
  expect_error(user_followers(user = NA))
  expect_error(user_followers(user = 4))

  user_following(user) %>%
    expect_is("tbl_df") %>%
    expect_length(7)

  user_friends(user) %>%
    expect_is("tbl_df") %>%
    expect_length(7)
})

test_that("No NULLs or \"\" in user_network", {
  friends <- user_followers("jemus42", "full")
  expect_true(!any(map_lgl(friends, function(col) any(is.null(col)))))
  expect_true(!any(map_lgl(friends, function(col) any(identical(col, "")))))
})
