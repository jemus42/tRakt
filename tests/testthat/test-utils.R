test_that("tRakt_sitrep works", {
	# tRakt_sitrep should run without errors and return nothing (invisible)
	expect_invisible(tRakt_sitrep())
})

test_that("can_device_auth works", {
	# can_device_auth should return a logical value
	result <- can_device_auth()
	expect_type(result, "logical")
	expect_length(result, 1)
})

test_that("get_client_secret works", {
	# get_client_secret should return either a character string or NULL
	# Don't record the actual value as it's sensitive
	result <- get_client_secret()
	expect_true(is.character(result) || is.null(result))
	if (!is.null(result)) {
		expect_length(result, 1)
		expect_true(nchar(result) > 0)
	}
})

test_that("print.trakt_token works", {
	# Test with a valid token
	valid_token <- list(
		created_at = as.numeric(Sys.time() - 3600), # Created 1 hour ago
		expires_in = 7200 # Expires in 2 hours (so still valid)
	)
	class(valid_token) <- "trakt_token"

	# Should print without error (uses cli output, not standard output)
	expect_invisible(print(valid_token))

	# Test with an expired token
	expired_token <- list(
		created_at = as.numeric(Sys.time() - 7200), # Created 2 hours ago
		expires_in = 3600 # Expired 1 hour ago
	)
	class(expired_token) <- "trakt_token"

	# Should print without error
	expect_invisible(print(expired_token))

	# Test that the objects have the right class
	expect_s3_class(valid_token, "trakt_token")
	expect_s3_class(expired_token, "trakt_token")
})

test_that("trakt_credentials works", {
	# trakt_credentials should run without errors
	# It shows information about available credentials and returns visibly
	expect_no_error(trakt_credentials())
})

test_that("trakt_credentials shows message when tRakt_key is not set", {
	# Test trakt_credentials behavior when tRakt_key environment variable is empty
	# Use withr to temporarily unset the environment variable
	withr::with_envvar(c(tRakt_key = ""), {
		# Should show a message about missing tRakt_key
		expect_message(trakt_credentials(), "Environment variable.*tRakt_key.*is not set")
	})
})

test_that("trakt_credentials shows different behavior with and without client secret", {
	# Test with both tRakt_key and trakt_client_secret unset
	withr::with_envvar(c(tRakt_key = "", trakt_client_secret = ""), {
		# Should show message about missing tRakt_key
		expect_message(trakt_credentials(), "Environment variable.*tRakt_key.*is not set")
	})

	# Test with trakt_client_secret set but tRakt_key unset
	withr::with_envvar(c(tRakt_key = "", trakt_client_secret = "fake_secret"), {
		# Should still show message about missing tRakt_key (since that's checked first)
		expect_message(trakt_credentials(), "Environment variable.*tRakt_key.*is not set")
	})
})

test_that("get_token behavior depends on authentication capability", {
	# The actual behavior depends on whether authentication is possible
	# and whether there's already a cached token, so we just verify it runs
	# without network errors (it might return a cached token or FALSE)
	result <- get_token()
	expect_true(is.logical(result) || inherits(result, "trakt_token"))
})

test_that("refresh_token handles invalid input correctly", {
	# Test refresh_token with invalid token structure
	# This should fail gracefully without making network requests

	# Test with invalid token (missing required fields)
	invalid_token <- list(invalid = TRUE)

	# This should error due to missing refresh_token field, not network issues
	expect_error(refresh_token(invalid_token, cache = FALSE))

	# Test with token that has correct structure but fake data
	fake_token <- list(
		refresh_token = "fake_refresh_token",
		access_token = "fake_access"
	)

	# This should make a network request but fail due to invalid credentials
	# We expect either an httr2 error or network error
	expect_error(refresh_token(fake_token, cache = FALSE))
})

test_that("oauth_device_token_poll handles invalid input correctly", {
	# Test oauth_device_token_poll with invalid device response

	# Test with invalid device response (missing required fields)
	invalid_request <- list(invalid = TRUE)

	# This should error due to missing required fields when accessing request$interval
	expect_error(oauth_device_token_poll(invalid_request))

	# Test with expired request (simulate expired device code)
	expired_request <- list(
		device_code = "fake_device_code",
		expires_in = -3600, # Already expired
		interval = 1
	)

	# This should exit the while loop immediately due to expired deadline
	# and return NULL (not error)
	result <- oauth_device_token_poll(expired_request)
	expect_null(result)
})

test_that("token_expired works correctly", {
	# Test with a valid (non-expired) token
	valid_token <- list(
		created_at = as.numeric(Sys.time() - 3600), # Created 1 hour ago
		expires_in = 7200 # Expires in 2 hours from creation (so still valid)
	)
	expect_false(token_expired(valid_token))

	# Test with an expired token
	expired_token <- list(
		created_at = as.numeric(Sys.time() - 7200), # Created 2 hours ago
		expires_in = 3600 # Expired 1 hour ago
	)
	expect_true(token_expired(expired_token))
})

test_that("token cache utilities work", {
	# Test that token_cache_loc returns a path
	cache_path <- token_cache_loc()
	expect_true(is.character(cache_path))
	expect_length(cache_path, 1)
	expect_true(nchar(cache_path) > 0)
	expect_true(grepl("\\.rds$", cache_path)) # Should end in .rds
})

test_that("cache_token and get_cached_token work with mock tokens", {
	# Create a mock token
	mock_token <- list(
		access_token = "mock_access_token",
		refresh_token = "mock_refresh_token",
		created_at = as.numeric(Sys.time()),
		expires_in = 3600
	)

	# Use withr to isolate the cache directory to avoid affecting real cache
	withr::with_tempdir({
		withr::with_options(list(tRakt_cache_dir = getwd()), {
			# Cache the mock token
			result <- cache_token(mock_token)
			expect_s3_class(result, "trakt_token")

			# Try to get cached token
			cached <- get_cached_token()
			expect_s3_class(cached, "trakt_token")
			expect_equal(cached$access_token, "mock_access_token")
		})
	})
})
