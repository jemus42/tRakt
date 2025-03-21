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
#' @importFrom curl curl_version
#' @family API-basics
#' @examples
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
    httr2::req_retry(max_tries = 3) |>
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
