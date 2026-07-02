#' Make an API call and receive parsed output
#'
#' The most basic form of API interaction: Querying a specific URL and getting
#' its parsed result. If the response is empty, the function returns an empty
#' [tibble()][tibble::tibble-package], and if there are date-time variables
#' present in the response, they are converted to `POSIXct` via
#' [lubridate::ymd_hms()] or to `Date` via [lubridate::as_date()] if the
#' variable only contains date information.
#'
#' @details
#' See [the official API reference](https://trakt.docs.apiary.io) for a detailed
#' overview of available methods. Most methods of potential interest for data
#' collection have dedicated functions in this package.

#' @param url `character(1)`: The API endpoint. Either a full URL like
#'   `"https://api.trakt.tv/shows/breaking-bad"` or just the endpoint like
#'   `shows/breaking-bad`.
#' @return The parsed content of the API response.
#'   An empty [tibble()][tibble::tibble-package] if the response is an empty
#'   `JSON` array.
#' @export
#' @import httr2
#' @family API-basics
#' @examplesIf trakt_api_available()
#' # A simple request to a direct URL
#' trakt_get("https://api.trakt.tv/shows/breaking-bad")
#'
#' # Optionally be lazy about URL specification by dropping the hostname:
#' trakt_get("shows/game-of-thrones")
trakt_get <- function(url) {
	if (!grepl(pattern = "^https://api.trakt.tv", url)) {
		url <- build_trakt_url(url)
	}

	if (!grepl(pattern = "^https://api.trakt.tv/\\w+", url)) {
		cli::cli_abort("Does not appear to be a valid trakt.tv API url: {.val {url}}")
	}

	req <- httr2::request(url) |>
		httr2::req_headers(
			# Additional headers required by the API
			"trakt-api-key" = get_client_id(),
			"Content-Type" = "application/json",
			"trakt-api-version" = "2"
		)

	token <- get_token()

	if (inherits(token, "trakt_token")) {
		req <- req |>
			httr2::req_auth_bearer_token(token = token$access_token)
	}

	req <- req |>
		httr2::req_retry(
			max_tries = 3,
			# Retry on connection failures and transient server errors. httr2's
			# default `is_transient` only covers 429 and 503, so the gateway
			# errors the trakt.tv API intermittently returns (502/504, and 500)
			# would otherwise surface as hard failures on a spurious blip.
			retry_on_failure = TRUE,
			is_transient = \(resp) {
				httr2::resp_status(resp) %in% c(429, 500, 502, 503, 504)
			}
		) |>
		httr2::req_cache(
			path = file.path(getOption("tRakt_cache_dir"), "data"),
			use_on_error = TRUE,
			max_age = getOption("tRakt_cache_max_age"),
			max_size = getOption("tRakt_cache_max_size"),
			debug = getOption("tRakt_debug")
		) |>
		httr2::req_user_agent(tRakt_user_agent())

	resp <- httr2::req_perform(req)
	httr2::resp_check_status(resp, info = url)

	# Handle empty responses (e.g. HTTP 204 No Content)
	if (httr2::resp_status(resp) == 204 || length(httr2::resp_body_raw(resp)) == 0) {
		return(tibble())
	}

	resp <- httr2::resp_body_json(resp, simplifyVector = TRUE, check_type = FALSE)

	# Kept from previous version, should be refactored at some point
	if (identical(resp, "") | length(resp) == 0) {
		return(tibble())
	}
	# Do it in every other function or do it here once
	if (!is.null(names(resp))) {
		resp <- fix_datetime(resp)
	}

	resp
}

#' Check whether the trakt.tv API is reachable
#'
#' A lightweight connectivity check that performs a single, small request to a
#' stable endpoint with a short timeout. It is primarily used to guard runnable
#' documentation examples (via roxygen2's `@examplesIf`) so they are executed
#' when the API is available but quietly skipped when it is not — avoiding
#' spurious failures from transient API outages or a missing internet
#' connection.
#'
#' This function never throws: it returns `FALSE` on any error (offline,
#' timeout, non-success status, ...) and does not retry.
#'
#' @return `logical(1)`: `TRUE` if the API responds successfully, else `FALSE`.
#' @export
#' @family API-basics
#' @examples
#' # Returns TRUE or FALSE, never errors:
#' trakt_api_available()
trakt_api_available <- function() {
	tryCatch(
		{
			resp <- httr2::request("https://api.trakt.tv/genres/shows") |>
				httr2::req_headers(
					"trakt-api-key" = get_client_id(),
					"trakt-api-version" = "2"
				) |>
				httr2::req_user_agent(tRakt_user_agent()) |>
				httr2::req_timeout(5) |>
				# Don't treat any status as an error; we inspect it ourselves.
				httr2::req_error(is_error = \(resp) FALSE) |>
				httr2::req_perform()

			httr2::resp_status(resp) < 400
		},
		error = function(e) FALSE
	)
}
