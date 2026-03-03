test_that("shows_summary works", {
	skip_on_cran()

	vcr::local_cassette("shows_summary_multiple")

	id <- c("breaking-bad", "dexter")
	show_min_df <- shows_summary(id)
	show_full_df <- shows_summary(id, extended = "full")

	show_min_df |>
		expect_tibble(min_cols = c("title", "year", "trakt", "slug"))

	show_full_df |>
		expect_tibble(min_cols = c("title", "year", "trakt", "slug"))

	expect_identical(
		shows_summary(c(id, id)),
		rbind(show_min_df, show_min_df)
	)
})

test_that("movies_summary works", {
	skip_on_cran()

	vcr::local_cassette("movies_summary_deadpool")

	id <- "deadpool-2016"
	movie_min_df <- movies_summary(id)

	movie_full_df <- movies_summary(id, extended = "full")

	movie_min_df |>
		expect_tibble(min_cols = c("title", "year", "trakt", "slug"))

	movie_full_df |>
		expect_tibble(min_cols = c("title", "year", "trakt", "slug"))

	expect_identical(
		movies_summary(c(id, id)),
		rbind(movie_min_df, movie_min_df)
	)
})

test_that("movies_summary with extended = 'images' returns images column", {
	skip_on_cran()

	vcr::local_cassette("movies_summary_images")

	id <- "deadpool-2016"
	movie_images_df <- movies_summary(id, extended = "images")

	movie_images_df |>
		expect_tibble(min_cols = c("title", "year", "trakt", "slug", "images"))

	expect_type(movie_images_df$images, "list")

	# Without images, same ID should NOT have images column
	movie_min_df <- movies_summary(id)
	expect_false("images" %in% names(movie_min_df))
})

test_that("shows_summary with extended = c('full', 'images') returns images", {
	skip_on_cran()

	vcr::local_cassette("shows_summary_full_images")

	id <- "breaking-bad"
	show_df <- shows_summary(id, extended = c("full", "images"))

	show_df |>
		expect_tibble(min_cols = c("title", "year", "trakt", "slug", "images"))

	expect_type(show_df$images, "list")

	# Should also have full info columns
	expect_true("overview" %in% names(show_df))
})
