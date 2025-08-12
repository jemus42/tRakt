test_that("media translations work", {
	skip_on_cran()

	vcr::local_cassette("media_translations")
	nm_movie <- c("title", "overview", "tagline", "language", "country")
	movies_translations("193972") |>
		expect_tibble(min_cols = nm_movie)

	nm_show <- c("title", "overview", "tagline", "language", "country")
	shows_translations("breaking-bad") |>
		expect_tibble(min_cols = nm_show)

	nm_ep <- c("title", "overview", "language", "country")
	episodes_translations("breaking-bad", 1, 3) |>
		expect_tibble(min_cols = nm_ep)
})
