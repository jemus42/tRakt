#' Set the required trakt.tv API credentials
#'
#' `trakt_credentials` searches for your credentials and stores them
#' in the appropriate [options()] variables of the same name.
#' To make this work automatically, place your key as environment variables in
#' `~/.Renviron` (see `Details`).
#' Arguments to this function take precedence over any key file. To make API
#' functions work, you do not have to use this function unless you want to
#' supply your own client ID, which is recommended for larger data collection
#' projects.
#'
#' Set appropriate values in your `~/.Renviron` like this:
#'
#' ```sh
#' # tRakt
#' trakt_username=jemus42
#' trakt_client_id=12[...]f2
#' trakt_client_secret=f23[...]2nkjb
#' ```
#'
#' @param username `character(1)`: Explicitly set your trakt.tv username
#'    (optional).
#' @param client_id `character(1)`: Explicitly set your API client ID
#'    (required for API interaciton).
#' @param silent `logical(1) [TRUE]`: No messages are printed showing you the
#'    API information.
#' Mostly for debug purposes.
#' @return Nothing. Only messages.
#' @export
#' @family API-basics
#' @examples
#' \dontrun{
#' # Use a values set in ~/.Renviron in an R session:
#' # (This is automatically executed when calling library(tRakt))
#' trakt_credentials()
#'
#' # Explicitly set values in an R session, overriding .Renviron values
#' trakt_credentials(
#'   username = "sean",
#'   client_id = "12fc1de7674[...]d5e11e3490823d629afdf2",
#'   silent = FALSE
#' )
#' }
trakt_credentials <- function(username, client_id, silent = TRUE) {
  username <- ifelse(missing(username),
    Sys.getenv("trakt_username"), username
  )
  client_id <- ifelse(missing(client_id),
    Sys.getenv("trakt_client_id"), client_id
  )

  if (username != "") {
    options(trakt_username = username)
    if (!silent) {
      message("Your trakt.tv username is set to ", getOption("trakt_username"))
    }
  }
  if (client_id != "") {
    options(trakt_client_id = client_id)
  } else {
    options(trakt_client_id = tRakt_client_id)
    if (!silent) {
      message(
        "I provided my client_id as a fallback for you. ",
        "Please use it responsibly."
      )
    }
  }

  if (!silent) {
    message(paste("Your client ID is set to", getOption("trakt_client_id")))
  }
}

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
#' @note No OAuth2 methods are supported yet, meaning you don't have access to
#'   `POST` methods or user information of non-public profiles.
#' @param url `character(1)`: The API endpoint. Either a full URL like
#'   `"https://api.trakt.tv/shows/breaking-bad"` or just the endpoint like
#'   `shows/breaking-bad`.
#' @param client_id `character(1)`: API client ID. If no value is set,
#'   this defaults to the package's client ID. See [trakt_credentials] for
#'   further information.
#' @param HEAD `logical(1) [FALSE]`: If `TRUE`, only a HTTP `HEAD` request is
#'   performed and its content returned. This is useful if you are only
#'   interested in status codes or other headers, and don't want to waste
#'   resources/bandwidth on the response body.
#' @param auth `logical(1) [FALSE]`: If `TRUE`, an authenticated request is made.
#'   This requires a set client secret and manual interaction.
#' @return The parsed ([jsonlite::fromJSON()]) content of the API response.
#'   An empty [tibble()][tibble::tibble-package] if the response is an empty
#'   `JSON` array.
#' @export
#' @importFrom httr user_agent config add_headers
#' @importFrom httr HEAD GET
#' @importFrom httr message_for_status status_code
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom purrr flatten
#' @importFrom purrr is_empty
#' @family API-basics
#' @examples
#' # A simple request to a direct URL
#' trakt_get("https://api.trakt.tv/shows/breaking-bad")
#'
#' # A HEAD-only request
#' # useful for validating a URL exists or the API is accessible
#' trakt_get("https://api.trakt.tv/users/jemus42", HEAD = TRUE)
#'
#' # Optionally be lazy about URL specification by dropping the hostname:
#' trakt_get("shows/game-of-thrones")
trakt_get <- function(url, client_id = getOption("trakt_client_id"),
                      HEAD = FALSE, auth = FALSE) {
  if (!grepl(pattern = "^https://api.trakt.tv", url)) {
    url <- build_trakt_url(url)
  }

  if (is.null(client_id)) {
    if (is.null(getOption("trakt_client_id"))) {
      options(trakt_client_id = tRakt_client_id)
    }
    client_id <- getOption("trakt_client_id")
  }

  # Headers and metadata
  agent <- user_agent("https://github.com/jemus42/tRakt")

  headers <- add_headers(.headers = c(
    "trakt-api-key" = client_id,
    "Content-Type" = "application/json",
    "trakt-api-version" = 2
  ))

  # Make the call
  if (HEAD) {
    response <- HEAD(url, headers, agent)
    response <- flatten(response$all_headers)
    return(response)
  }

  token <- NULL
  if (auth) token <- trakt_get_token()

  response <- GET(url, headers, agent, config(token = token))

  # Fail on HTTP error, i.e. 404 or 5xx.
  if (status_code(response) >= 300) {
    message_for_status(response, paste0("retrieve data from\n", url))
  }

  # Parse output
  response <- content(response, as = "text", encoding = "UTF-8")

  if (identical(response, "")) {
    return(tibble())
  }

  response <- fromJSON(response)

  # To make empty response handling easier
  if (is_empty(response)) {
    return(tibble())
  }

  # Do it in every other function or do it here once
  if (!is.null(names(response))) {
    response <- fix_datetime(response)
  }

  response
}

#' Get a trakt.tv OAuth2 token
#'
#' This is used internally for authenticated requests.
#' @return An OAuth2 token object. See [oauth2.0_token][httr::oauth2.0_token].
#' @keywords internal
#' @family API-basics
#' @importFrom httr oauth_endpoint oauth_app oauth2.0_token user_agent
trakt_get_token <- function() {
  # Set up OAuth URLs
  trakt_endpoint <- oauth_endpoint(
    authorize = "https://trakt.tv/oauth/authorize",
    access = "https://api.trakt.tv/oauth/token"
  )

  # Application credentials: https://trakt.tv/oauth/applications
  app <- oauth_app(
    appname = "trakt",
    key = getOption("trakt_client_id"),
    secret = Sys.getenv("trakt_client_secret"),
    redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
  )

  # 3. Get OAuth credentials
  oauth2.0_token(
    trakt_endpoint, app,
    use_oob = TRUE,
    config_init = user_agent("https://github.com/jemus42/tRakt")
  )
}
