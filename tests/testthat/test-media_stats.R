test_that("user_stats works for 1 user", {
	skip_on_cran()

	vcr::local_cassette("user_stats_single")

	userstats <- user_stats(user = "jemus42")

	expect_type(userstats, "list")
	expect_named(
		userstats,
		c(
			"movies",
			"shows",
			"seasons",
			"episodes",
			"network",
			"ratings"
		)
	)
})

test_that("user_stats works for multiple users", {
	skip_on_cran()

	vcr::local_cassette("user_stats_multiple")

	users <- c("jemus42", "sean")

	userstats <- user_stats(user = users)
	expect_type(userstats, "list")
	expect_named(userstats, users)
	expect_named(
		userstats[[users[[1]]]],
		c(
			"movies",
			"shows",
			"seasons",
			"episodes",
			"network",
			"ratings"
		)
	)
})

test_that("media_stats does things", {
	skip_on_cran()

	vcr::local_cassette("media_stats_basic")

	shows_stats(id = "futurama") |>
		expect_tibble(exact_rows = 1)

	stats_mov <- movies_stats(id = "deadpool-2016") |>
		expect_tibble(exact_rows = 1)

	stats_multi <- shows_stats(id = c("futurama", "breaking-bad"))
	expect_equal(nrow(stats_multi), 2)
})

test_that("seasons_stats works", {
	vcr::local_cassette("seasons_stats_futurama")

	res <- seasons_stats("futurama", 1:2) |>
		expect_tibble()

	res$season |> expect_equal(1:2)
})

test_that("episodes_stats works", {
	vcr::local_cassette("episodes_stats_futurama")

	res <- episodes_stats("futurama", 1:2, 3:4) |>
		expect_tibble()

	res$season |> expect_equal(c(1, 1, 2, 2))
	res$episode |> expect_equal(c(3, 4, 3, 4))
})
