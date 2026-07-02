# Unit tests for the filter builders / validators. These use bundled lookup
# data (trakt_genres, trakt_networks, ...) and do not touch the API.

test_that("filters_shows builds a validated trakt_filters object", {
	f <- filters_shows(genres = "action", years = c(2016, 2020), status = "ended")

	expect_s3_class(f, "trakt_filters")
	expect_identical(f$genres, "action")
	expect_identical(f$years, "2016-2020")
	expect_identical(f$status, "ended")
})

test_that("empty builder yields an empty object; NULLs are dropped", {
	f <- filters_movies()
	expect_s3_class(f, "trakt_filters")
	expect_length(f, 0)

	f2 <- filters_movies(genres = "action", years = NULL)
	expect_named(f2, "genres")
})

test_that("numeric range filters normalize to 'lo-hi' and respect bounds", {
	# Trakt ratings: integer 0-100
	expect_identical(filters_movies(ratings = c(75, 100))$ratings, "75-100")
	# Order-insensitive
	expect_identical(filters_movies(ratings = c(100, 75))$ratings, "75-100")
	# Single value allowed
	expect_identical(filters_movies(runtimes = 90)$runtimes, "90")
	# Decimal scale preserved for imdb/tmdb ratings
	expect_identical(filters_movies(imdb_ratings = c(8, 10))$imdb_ratings, "8-10")

	# Out-of-range warns and drops the filter
	expect_warning(f <- filters_movies(ratings = c(75, 200)), "between")
	expect_null(f$ratings)
})

test_that("vocabulary filters validate against bundled data (case-insensitive)", {
	# Known genre passes through as its canonical slug
	expect_identical(filters_shows(genres = "Action")$genres, "action")

	# Unknown value warns and is dropped
	expect_warning(f <- filters_shows(genres = "not-a-genre"), "unknown")
	expect_null(f$genres)

	# Multiples are comma-joined
	expect_identical(filters_shows(genres = c("action", "comedy"))$genres, "action,comedy")
})

test_that("status accepts the expanded vocabulary", {
	expect_identical(filters_shows(status = "continuing")$status, "continuing")
	expect_identical(filters_shows(status = "upcoming")$status, "upcoming")
})

test_that("networks are name-validated; network_ids are integer-validated", {
	# Duplicate/case-variant names (e.g. Netflix) resolve to a single value
	nf <- filters_shows(networks = "Netflix")$networks
	expect_length(nf, 1)
	expect_match(nf, "Netflix", ignore.case = TRUE)

	expect_identical(filters_shows(network_ids = c(53L, 42L))$network_ids, "53,42")
	expect_warning(f <- filters_shows(network_ids = "abc"), "integer")
	expect_null(f$network_ids)
})

test_that("builders only expose filters valid for their media type", {
	# Rotten Tomatoes / Metacritic are movies-only in the API
	expect_true("rt_meters" %in% names(formals(filters_movies)))
	expect_false("rt_meters" %in% names(formals(filters_shows)))
	# status / networks are shows-only
	expect_true("status" %in% names(formals(filters_shows)))
	expect_false("status" %in% names(formals(filters_movies)))
	# episode_types is episodes-only
	expect_true("episode_types" %in% names(formals(filters_episodes)))
	expect_false("episode_types" %in% names(formals(filters_shows)))
})

test_that("as_trakt_filters coerces NULL and rejects bad input", {
	expect_length(as_trakt_filters(NULL), 0)
	expect_s3_class(as_trakt_filters(filters_movies(genres = "action")), "trakt_filters")
	expect_error(as_trakt_filters(list(genres = "action")), "trakt_filters")
})

test_that("resolve_filters: filters object alone produces no warning", {
	expect_no_warning(
		f <- resolve_filters(filters_shows(genres = "comedy"), list(), context = "shows")
	)
	expect_identical(f$genres, "comedy")
})

test_that("resolve_filters: legacy flat args are soft-deprecated but still work", {
	expect_warning(
		f <- resolve_filters(NULL, list(genres = "action"), context = "shows"),
		class = "lifecycle_warning_deprecated"
	)
	expect_identical(f$genres, "action")
})

test_that("resolve_filters: when both are supplied, filters wins with a warning", {
	w <- testthat::capture_warnings(
		f <- resolve_filters(
			filters_shows(genres = "comedy"),
			list(genres = "action"),
			context = "shows"
		)
	)
	# filters object takes precedence over the flat argument
	expect_identical(f$genres, "comedy")
	expect_true(any(grepl("both", w, ignore.case = TRUE)))
	expect_true(any(grepl("deprecat", w, ignore.case = TRUE)))
})

test_that("print method renders and returns its input invisibly", {
	empty <- paste(cli::cli_fmt(print(filters_movies())), collapse = " ")
	expect_match(empty, "empty")

	nonempty <- paste(cli::cli_fmt(print(filters_shows(genres = "action"))), collapse = " ")
	expect_match(nonempty, "genres")

	expect_invisible(print(filters_movies()))
})
