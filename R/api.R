#' Set the required trakt.tv API credentials
#'
#' `trakt_credentials` searches for your credentials and stores them
#' in the appropriate `option` variables.
#' It also sets the HTTP header required for v2 API calls.
#' To make this work automatically, place your key as environment variables in
#' `~/.Renviron`.
#' Arguments to this function take precedence over any key file.
#'
#' Set appropriate values in your `~/.Renviron` like this:
#'
#' ```sh
#' # tRakt
#' trakt_username=jemus42
#' trakt_client_id=12[...]f2
#' ```
#'
#' @param username `character(1)`: Explicitly set your trakt.tv username (optional).
#' @param client.id `character(1)`: Explicitly set your APIv2 client id (required for API interaciton).
#' @param silent `logical(1) [TRUE]`: No messages are printed showing you the API information.
#' Mostly for debug purposes.
#' @return Nothing. Only messages.
#' @export
#' @note Please note that no OAuth2 methods are supported yet,
#' only client id really matters.
#' @family API-basics
#' @examples
#' \dontrun{
#' # Use a values set in ~/.Renviron in an R session:
#' # (This is automatically executed when calling library(tRakt))
#' trakt_credentials()
#'
#' # Explicitly set values in an R session, overriding .Renviron values if present
#' trakt_credentials(
#'   username = "sean",
#'   client.id = "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2"
#' )
#' }
trakt_credentials <- function(username, client.id,
                                  silent = TRUE) {
  username <- ifelse(missing(username), Sys.getenv("trakt_username"), username)
  client_id <- ifelse(missing(client.id), Sys.getenv("trakt_client_id"), client.id)

  if (username != "") {
    options(trakt.username = username)
    if (!silent) {
      message(paste("Your trakt.tv username is set to", getOption("trakt.username")))
    }
  }
  if (client_id != "") {
    options(trakt.client.id = client_id)
  } else {
    options(trakt.client.id = tRakt_client_id)
    if (!silent) {
    message("I provided my client.id as a fallback for you. Please use it responsibly.")
    }
  }

  if (!silent) {
    message(paste("Your client id is set to", getOption("trakt.client.id")))
  }
}

#' Make an API call to any URL
#'
#' `trakt.api.call` makes an API call to a specified URL and returns the parsed output.
#'
#' @param url APIv2 method. See \href{http://docs.trakt.apiary.io/}{the trakt API}.
#' @param client.id API client id. see [trakt_credentials] for further information.
#' @param convert.datetime If `TRUE` (default), known top-level datetime variables
#' are converted to `POSIXct`. This might miss some variables and does not recurse
#' into nested lists or list-columns.
#' @param HEAD `logical(1) [FALSE]`: If `TRUE`, only a HTTP `HEAD` request is performed
#' and its content returned. This is useful if you are only interested in status codes
#' or other headers, and don't want to waste resources on additional bandwidth.
#' @return The [parsed][jsonlite::fromJSON] content of the API response.
#' An empty [tibble][tibble::tibble-package] if the response is an empty `JSON` array.
#' @export
#' @importFrom httr user_agent
#' @importFrom httr add_headers
#' @importFrom httr HEAD
#' @importFrom httr GET
#' @importFrom httr stop_for_status
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom purrr flatten
#' @family API-basics
#' @examples
#' # A simple request to a direct URL
#' trakt.api.call("https://api.trakt.tv/shows/breaking-bad")
#'
#' # A HEAD-only request useful for validating a URL exists
#' trakt.api.call("https://api.trakt.tv/users/jemus42", HEAD = TRUE)
#'
#' # Optionally be lazy about URL specification (not encouraged):
#' trakt.api.call("shows/game-of-thrones")
trakt.api.call <- function(url, client.id = getOption("trakt.client.id"),
                           convert.datetime = TRUE, HEAD = FALSE) {

  if (!grepl(pattern = "^https://api.trakt.tv", url)) {
    url <- build_trakt_url(url)
  }

  if (is.null(client.id)) {
    if (is.null(getOption("trakt.client.id"))) {
      options(trakt.client.id = tRakt_client_id)
    }
    client.id <- getOption("trakt.client.id")
  }

  # Headers and metadata
  agent <- httr::user_agent("https://github.com/jemus42/tRakt")

  headers <- httr::add_headers(.headers = c(
    "trakt-api-key" = client.id,
    "Content-Type" = "application/json",
    "trakt-api-version" = 2
  ))

  # Make the call
  if (HEAD) {
    response <- httr::HEAD(url, headers, agent)
    response <- purrr::flatten(response$all_headers)
    return(response)
  }

  response <- httr::GET(url, headers, agent)
  # Fail on HTTP error, i.e. 404 or 5xx.
  httr::stop_for_status(response, paste0("retrieve data from ", url))

  # Parse output
  response <- httr::content(response, as = "text")
  response <- jsonlite::fromJSON(response)

  # To make empty response handling easier
  if (identical(response, list()) | is.null(response)) {
    return(tibble::tibble())
  }

  # Do it in every other function or do it here once
  if (convert.datetime & !is.null(names(response))) {
    response <- convert_datetime(response)
  }

  response
}
