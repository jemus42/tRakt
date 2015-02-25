#' Set the required trakt.tv API credentials
#'
#' \code{get_trakt_credentials} searches for your credentials and stores them
#' in the appropriate \code{option} variables.
#' It also sets the HTTP header required for v2 API calls.
#' To make this work automatically, place a \code{key.json} file either in the working directory
#' or in \code{~/.config/trakt/key.json}.
#' Arguments to this function take precedence over any key file.
#'
#' @param username Explicitly set your trakt.tv username (Not used yet)
#' @param client.id Explicitly set your APIv2 client id
#' @param client.secret Explicitly set your APIv2 client secret
#' @param set.headers \code{TRUE} by default. Sets the \code{httr} headers
#' for \code{GET} requests for the APIv2
#' @param silent If TRUE (default), no messages are printed showing you the API information.
#' Mostly for debug purposes.
#' @return Nothing. Only messages.
#' @export
#' @importFrom jsonlite fromJSON
#' @note Please note that no oauth2 methods are supported yet,
#' only client id really matters.
#' @family API
#' @examples
#' \dontrun{
#' # Use a key.json
#' get_trakt_credentials()
#'
#' # Explicitly set values
#' get_trakt_credentials(username = "sean",
#' client.id = "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2")
#' }
get_trakt_credentials <- function(username = NULL, client.id = NULL,
                                  client.secret = NULL, set.headers = TRUE,
                                  silent = TRUE){
  # Finding/setting key file
  if (file.exists("~/.config/trakt/key.json")){
    keyfile <- "~/.config/trakt/key.json"
  } else if (file.exists("key.json")){
    keyfile <- "./key.json"
  } else {
    keyfile <- NULL
  }
  if (!(is.null(keyfile))){
    if (!silent) message(paste("Reading credentials from", keyfile))
  } else {
    if (!silent) message("No keyfile set/found")
  }

  # Setting username (just in case)
  if (!is.null(username)){
    options(trakt.username = username)
  } else if (!(is.null(keyfile))){
    options(trakt.username = jsonlite::fromJSON(keyfile)[["username"]])
  } else {
    if (!silent) warning("Couldn't find your username")
  }

  # Setting v2 client id
  if (!(is.null(client.id))){
    options(trakt.client.id = client.id)
  } else if (!(is.null(keyfile))){
    options(trakt.client.id = jsonlite::fromJSON(keyfile)[["client.id"]])
  } else {
    if (!silent) warning("Couldn't find your client id")
  }

  # Setting v2 client secret (not used yet)
  if (!(is.null(client.secret))){
    options(trakt.client.secret = client.id)
  } else if (!(is.null(keyfile))){
    options(trakt.client.secret = jsonlite::fromJSON(keyfile)[["client.secret"]])
  } else {
    if (!silent) warning("Couldn't find your client secret")
  }

  if (!silent){
    # Communicate the above
    message("Please check if everything seems right:")
    message(paste("Your trakt.tv username is set to",   getOption('trakt.username')))
    message(paste("Your APIv2 client id is set to",     getOption('trakt.client.id')))
    message("Your APIv2 client secret is set (not displayed for privacy reasons)")
  }

  if (is.null(getOption("trakt.client.id"))){
    options(trakt.client.id = "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2")
    warning("I provided my client.id as a fallback for you. Use it responsibly.")
  }

  # Set the appropriate header for httr::GET
  if (set.headers){
    headers <- httr::add_headers(.headers = c("trakt-api-key"     = getOption("trakt.client.id"),
                                              "Content-Type"      = "application/json",
                                              "trakt-api-version" = 2))
    options(trakt.headers = headers)
    if (!silent){
      message("HTTP headers set, retrieve via getOption('trakt.headers')")
    }
  }
}

#' Make an APIv2 call to any URL
#'
#' \code{trakt.api.call} makes an APIv2 call to a specified URL
#' and returns the output \code{jsonlite::fromJSON}'d if requested.
#'
#' @param url APIv2 method. See \href{http://docs.trakt.apiary.io/}{the trakt API}.
#' @param headers HTTP headers to set. Must be result of \code{httr::add_headers}.
#' Default value is \code{getOption("trakt.headers")} set by \link[tRakt]{get_trakt_credentials}.
#' @param fromJSONify If \code{TRUE} (default), the API response will be converted to an object via
#' \code{jsonlite::fromJSON}
#' @param convert.datetime If \code{TRUE} (default), datetime variables are converted to
#' \code{POSIXct}. Requires \code{fromJSONify} to be \code{TRUE} as well.
#' @return The content of the API response, \code{jsonlite::fromJSON}'d if requested.
#' @export
#' @import httr
#' @importFrom jsonlite fromJSON
#' @note This function is heavily used internally, so why not expose it to the user.
#' @family API
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.api.call("https://api-v2launch.trakt.tv/shows/breaking-bad?extended=min")
#' }
trakt.api.call <- function(url, headers = getOption("trakt.headers"), fromJSONify = TRUE,
                           convert.datetime = TRUE){
  response   <- httr::GET(url, headers)
  httr::stop_for_status(response) # In case trakt fails
  response   <- httr::content(response, as = "text")
  if (fromJSONify){
    response <- jsonlite::fromJSON(response)
    if (convert.datetime){
      response <- convert_datetime(response)
    }
  }
  return(response)
}
