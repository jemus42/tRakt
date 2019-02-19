#' Set the required trakt.tv API credentials
#'
#' `get_trakt_credentials` searches for your credentials and stores them
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
#' @param set.headers `logical(1) [TRUE]`: Sets the `httr` headers
#' for `GET` requests to the APIv2.
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
#' get_trakt_credentials()
#'
#' # Explicitly set values in an R session, overriding .Renviron values f present
#' get_trakt_credentials(
#'   username = "sean",
#'   client.id = "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2"
#' )
#' }
get_trakt_credentials <- function(username = "", client.id = "",
                                  set.headers = TRUE,
                                  silent = TRUE) {

  username  <- ifelse(username == "", Sys.getenv("trakt_username"), username)
  client_id <- ifelse(client.id == "", Sys.getenv("trakt_client_id"), client.id)

  if (username != "") {
    options(trakt.username = username)
    if (!silent) {
      message(paste("Your trakt.tv username is set to", getOption("trakt.username")))
    }
  }
  if (client_id != "") {
    options(trakt.client.id = client_id)
  } else {
    options(trakt.client.id = "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2")
    message("I provided my client.id as a fallback for you. Please use it responsibly.")
  }

  if (!silent) {
    message(paste("Your APIv2 client id is set to", getOption("trakt.client.id")))
  }

  # Set the appropriate header for httr::GET
  if (set.headers) {
    headers <- httr::add_headers(.headers = c(
      "trakt-api-key" = getOption("trakt.client.id"),
      "Content-Type" = "application/json",
      "trakt-api-version" = 2
    ))
    options(trakt.headers = headers)
    if (!silent) {
      message("HTTP headers set, retrieve via getOption('trakt.headers')")
    }
  }
}

#' Make an APIv2 call to any URL
#'
#' `trakt.api.call` makes an APIv2 call to a specified URL
#' and returns the output `jsonlite::fromJSON`'d if requested.
#'
#' @param url APIv2 method. See \href{http://docs.trakt.apiary.io/}{the trakt API}.
#' @param headers HTTP headers to set. Must be result of `httr::add_headers`.
#' Default value is `getOption("trakt.headers")` set by \link[tRakt]{get_trakt_credentials}.
#' @param fromJSONify If `TRUE` (default), the API response will be converted to an object via
#' `jsonlite::fromJSON`
#' @param convert.datetime If `TRUE` (default), datetime variables are converted to
#' `POSIXct`. Requires `fromJSONify` to be `TRUE` as well.
#' @return The content of the API response, `jsonlite::fromJSON`'d if requested.
#' @export
#' @import httr
#' @importFrom jsonlite fromJSON
#' @note This function is heavily used internally, so why not expose it to the user.
#' @family API-basics
#' @examples
#' \dontrun{
#' library(tRakt)
#' trakt.api.call("https://api-v2launch.trakt.tv/shows/breaking-bad?extended=min")
#' }
trakt.api.call <- function(url, headers = getOption("trakt.headers"), fromJSONify = TRUE,
                           convert.datetime = TRUE) {
  if (is.null(headers) & is.null(getOption("trakt.headers"))) {
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  response <- httr::GET(url, headers)
  httr::stop_for_status(response) # In case trakt fails
  response <- httr::content(response, as = "text")
  if (fromJSONify) {
    response <- jsonlite::fromJSON(response)
    if (convert.datetime) {
      response <- convert_datetime(response)
    }
  }
  return(response)
}
