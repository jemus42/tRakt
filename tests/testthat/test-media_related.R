test_that("media_related works", {
	skip_on_cran()

	vcr::local_cassette("media_related_shows_movies")

	show <- "futurama"
	movie <- "inception-2010"

	rel_show <- shows_related(id = show)
	rel_show_min <- shows_related(id = show, extended = "min")
	rel_show_max <- shows_related(id = show, extended = "full")

	expect_s3_class(rel_show, "tbl")
	expect_identical(rel_show, rel_show_min)
	expect_gt(ncol(rel_show_max), ncol(rel_show))
	expect_equal(nrow(rel_show), 10)

	expect_identical(
		rbind(
			shows_related(id = show),
			shows_related(id = show)
		),
		shows_related(id = c(show, show))
	)

	rel_movie <- movies_related(id = movie)
	rel_movie_min <- movies_related(id = movie, extended = "min")
	rel_movie_max <- movies_related(id = movie, extended = "full")

	expect_s3_class(rel_movie, "tbl")
	expect_identical(rel_movie, rel_movie_min)
	expect_gt(ncol(rel_movie_max), ncol(rel_movie))
	expect_equal(nrow(rel_movie), 10)

	# Error conditions ----
	expect_error(movies_related(id = NA))
	expect_error(movies_related(id = movie, extended = "a lot"))
})
