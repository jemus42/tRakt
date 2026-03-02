# fix_ids ----

test_that("fix_ids handles show-level plex (guid + slug)", {
	ids <- data.frame(
		trakt = "1",
		slug = "test-show",
		imdb = "tt1234",
		tmdb = "100",
		tvdb = "200",
		stringsAsFactors = FALSE
	)
	ids$plex <- data.frame(guid = "abc123", slug = "test-slug")

	result <- fix_ids(ids)

	expect_true("plex_guid" %in% names(result))
	expect_true("plex_slug" %in% names(result))
	expect_false("plex" %in% names(result))
	expect_equal(result$plex_guid, "abc123")
	expect_equal(result$plex_slug, "test-slug")
})

test_that("fix_ids handles season/episode-level plex (guid only, no slug)", {
	ids <- data.frame(
		trakt = c("1", "2", "3"),
		tmdb = c("10", "20", "30"),
		tvdb = c("100", "200", "300"),
		stringsAsFactors = FALSE
	)
	ids$plex <- data.frame(guid = c("aaa", "bbb", "ccc"))

	result <- fix_ids(ids)

	expect_true("plex_guid" %in% names(result))
	# plex_slug should not be created when slug is absent from plex
	expect_false("plex_slug" %in% names(result))
	expect_false("plex" %in% names(result))
	expect_equal(result$plex_guid, c("aaa", "bbb", "ccc"))
})

test_that("fix_ids handles list input with plex", {
	ids <- list(
		trakt = "1",
		slug = "test",
		imdb = "tt1234",
		tmdb = "100",
		plex = list(guid = "abc123", slug = "test-slug")
	)

	result <- fix_ids(ids)

	expect_equal(result$plex_guid, "abc123")
	expect_equal(result$plex_slug, "test-slug")
	expect_false("plex" %in% names(result))
})

test_that("fix_ids handles NULL plex", {
	ids <- list(
		trakt = "1",
		slug = "test",
		plex = NULL
	)

	result <- fix_ids(ids)

	# NULL plex should not produce plex columns
	expect_false("plex_guid" %in% names(result))
	expect_false("plex_slug" %in% names(result))
})

test_that("fix_ids handles ids without plex at all", {
	ids <- data.frame(
		trakt = "1",
		slug = "test",
		imdb = "tt1234",
		stringsAsFactors = FALSE
	)

	result <- fix_ids(ids)

	expect_false("plex_guid" %in% names(result))
	expect_false("plex_slug" %in% names(result))
})

test_that("fix_ids drops tvrage", {
	ids <- data.frame(
		trakt = "1",
		tvrage = "999",
		stringsAsFactors = FALSE
	)

	result <- fix_ids(ids)

	expect_false("tvrage" %in% names(result))
})

test_that("fix_ids replaces NULL values with NA", {
	ids <- list(trakt = "1", imdb = NULL, tmdb = "100")

	result <- fix_ids(ids)

	expect_true(is.na(result$imdb))
	expect_equal(result$tmdb, "100")
})

test_that("fix_ids converts all values to character", {
	ids <- data.frame(trakt = 1L, tmdb = 100L, tvdb = 200L)

	result <- fix_ids(ids)

	expect_type(result$trakt, "character")
	expect_type(result$tmdb, "character")
	expect_type(result$tvdb, "character")
})

test_that("fix_ids rejects non-list/data.frame input", {
	expect_error(fix_ids("not_valid"), "must be a list or data.frame")
	expect_error(fix_ids(42), "must be a list or data.frame")
})

# fix_datetime ----

test_that("fix_datetime converts datetime columns", {
	skip_if_not_installed("lubridate")

	res <- tibble::tibble(updated_at = as.character(lubridate::now()))

	res <- fix_datetime(res)
	expect_s3_class(res$updated_at, "POSIXct")
	expect_equal(attr(res$updated_at, "tzone"), "UTC")
	expect_error(fix_datetime("not_a_df_or_list"))
})

test_that("fix_datetime doesn't re-convert POSIXct", {
	res <- tibble::tibble(
		updated_at = lubridate::ymd_hms("2024-01-01 12:00:00")
	)

	result <- fix_datetime(res)
	expect_identical(res$updated_at, result$updated_at)
})

test_that("fix_datetime converts released to Date", {
	res <- tibble::tibble(released = "2024-06-15")

	result <- fix_datetime(res)
	expect_s3_class(result$released, "Date")
})

# fix_ratings ----

test_that("fix_ratings sets rating to NA when votes is 0", {
	res <- tibble::tibble(rating = c(8.5, 7.0, 0.0), votes = c(100, 0, 50))

	result <- fix_ratings(res)

	expect_equal(result$rating, c(8.5, NA, 0.0))
})

test_that("fix_ratings passes through when columns are missing", {
	res <- tibble::tibble(title = "test")

	result <- fix_ratings(res)

	expect_identical(res, result)
})

# fix_tibble_response ----

test_that("fix_tibble_response drops images column", {
	res <- data.frame(title = "Test", rating = 8.0, votes = 100)
	res$images <- data.frame(screenshot = I(list("http://example.com/img.jpg")))

	result <- fix_tibble_response(res)

	expect_false("images" %in% names(result))
	expect_true("title" %in% names(result))
})

test_that("fix_tibble_response drops colors column", {
	res <- data.frame(title = "Test", rating = 8.0, votes = 100)
	res$colors <- data.frame(primary = "#ff0000", accent = "#00ff00")

	result <- fix_tibble_response(res)

	expect_false("colors" %in% names(result))
})

test_that("fix_tibble_response returns a tibble", {
	res <- data.frame(title = "Test", year = 2024L)

	result <- fix_tibble_response(res)

	expect_s3_class(result, "tbl_df")
})
