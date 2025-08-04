test_that("user_network stuff works", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user-user-friendfollow_basic")

	user <- "jemus42"

	fol_min <- user_followers(user = user, extended = "min")
	fol_max <- user_followers(user = user, extended = "full")

	expect_s3_class(fol_min, "tbl")
	expect_s3_class(fol_max, "tbl")
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

	user_following(user) |>
		expect_s3_class("tbl_df")

	user_friends(user) |>
		expect_s3_class("tbl_df")
})

test_that("No NULLs or \"\" in user_network", {
	friends <- user_followers("jemus42", "full")
	expect_true(!any(map_lgl(friends, function(col) any(is.null(col)))))
	expect_true(!any(map_lgl(friends, function(col) any(identical(col, "")))))
})
