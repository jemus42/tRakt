test_that("movies_updates and shows_updates return updated media", {
	skip_on_cran()

	vcr::local_cassette("updated_media")

	m <- movies_updates(limit = 3, start_date = "2026-06-25")
	expect_tibble(m, min_cols = c("updated_at", "title", "year", "trakt"))

	s <- shows_updates(limit = 3, start_date = "2026-06-25")
	expect_s3_class(s, "tbl")
	expect_true("updated_at" %in% names(s))
})

test_that("updates start_date is validated", {
	# Invalid input errors before any request
	expect_error(movies_updates(start_date = "not-a-date"), "start_date")

	# Dates older than 30 days warn (the API returns nothing for them)
	expect_warning(check_update_start_date(Sys.Date() - 45), "30 days")

	# A recent date passes through as a character string
	expect_identical(check_update_start_date(as.Date("2026-06-25")), "2026-06-25")
})
