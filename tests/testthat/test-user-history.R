test_that("user_history does things", {
	skip_on_cran()
	)

	vcr::local_cassette("user-user-history_basic")

	user_history(user = "jemus42", "shows") |>
		expect_s3_class("tbl") |>
		expect_length(18) |>
		nrow() |>
		expect_equal(10)

	user_history(user = "jemus42", "movies") |>
		expect_s3_class("tbl") |>
		expect_length(10) |>
		nrow() |>
		expect_equal(10)

	user_history(user = c("jemus42", "sean"), limit = 2) |>
		expect_s3_class("tbl") |>
		expect_length(19) |>
		nrow() |>
		expect_equal(4)
})
