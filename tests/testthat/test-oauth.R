# OAuth / token-handling tests. These mock the HTTP layer (httr2) and the
# credential helpers so no real authentication or network access is needed.

test_that("get_token returns a valid cached token without any request", {
	fake <- structure(
		list(access_token = "cached", refresh_token = "r", expires_in = 86400),
		class = "trakt_token"
	)
	local_mocked_bindings(get_cached_token = function(...) fake)

	# No mocked responses are registered, so any HTTP call would error — proving
	# the cached token short-circuits the request.
	expect_identical(get_token(), fake)
})

test_that("get_token returns FALSE when device auth is unavailable", {
	local_mocked_bindings(
		get_cached_token = function(...) NULL,
		can_device_auth = function(...) FALSE
	)
	expect_false(get_token())
})

test_that("refresh_token parses and returns a refreshed token", {
	local_mocked_bindings(get_client_secret = function(...) "secret")
	httr2::local_mocked_responses(list(
		httr2::response_json(
			body = list(
				access_token = "new_access",
				refresh_token = "new_refresh",
				expires_in = 86400,
				token_type = "bearer"
			)
		)
	))

	new <- refresh_token(list(refresh_token = "old_refresh"), cache = FALSE)

	expect_equal(new$access_token, "new_access")
	expect_equal(new$refresh_token, "new_refresh")
})

test_that("refresh_token caches the token when cache = TRUE", {
	local_mocked_bindings(get_client_secret = function(...) "secret")
	httr2::local_mocked_responses(list(
		httr2::response_json(body = list(access_token = "a", refresh_token = "b"))
	))

	cached <- NULL
	local_mocked_bindings(cache_token = function(token, ...) {
		cached <<- token
		invisible(token)
	})

	refresh_token(list(refresh_token = "old"), cache = TRUE)
	expect_equal(cached$access_token, "a")
})
