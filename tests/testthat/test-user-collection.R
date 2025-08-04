test_that("user_collection works", {
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user_collection_basic")

	user <- "jemus42"

	col_sho <- user_collection(user = user, type = "shows", unnest_episodes = FALSE)

	col_sho |>
		expect_s3_class("tbl")

	user_collection(user = user, type = "movies") |>
		expect_s3_class("tbl")

	user_collection(user = c("jemus42", "sean"), type = "movies") |>
		expect_s3_class("tbl")

	# Error conditions ----
	expect_error(user_collection(user = -1))
	expect_error(user_collection(user = c("jemus42", "totallynotarealuser")))
	expect_error(user_collection(user = user, type = "wurst"))
})

# The unnesting thing ----

test_that("user_collection works with episode unnesting", {
	skip_if_not_installed("tidyr")
	skip_on_cran()
	skip_if_not_installed("vcr")

	vcr::local_cassette("user_collection_unnest_episodes")

	user <- "jemus42"
	col_eps <- user_collection(user = user, type = "shows", unnest_episodes = TRUE)

	expect_s3_class(col_eps, "tbl")
	expect_equal(ncol(col_eps), 12)
	expect_gt(nrow(col_eps), 10)
	expect_s3_class(col_eps$collected_at, "POSIXct")
})
