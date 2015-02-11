#' Set the required trakt.tv API credentials
#' 
#' \code{get_trakt_credentials} searches for your credentials and stores them 
#' in the appropriate \code{option} variables. 
#' It also sets the HTTP header required for v2 API calls.
#' To make this work, place a \code{key.json} file either in the working directory
#' or in \code{~/.config/trakt/key.json}.
#' Arguments to this function take precedence over any key file.
#' 
#' @param apikey Explicitly set your APIv1 key
#' @param username Explicitly set your trakt.tv username (Not used yet)
#' @param client.id Explicitly set your APIv2 client id
#' @param client.secret Explicitly set your APIv2 client secret
#' @param set.headers \code{TRUE} by default. Sets the \code{httr} headers for \code{GET} requests
#' for the APIv2
#' @return Nothing. Only messages.
#' @export
#' @importFrom jsonlite fromJSON
#' @note This function includes both the old v1 API key as well
#' as the v2 API keys (client id and client secret).
#' Please note that no oauth2 methods are supported yet, 
#' only client id really matters.
#' @examples
#' \dontrun{
#' get_trakt_credentials()
#' }
get_trakt_credentials <- function(apikey = NULL, username = NULL, client.id = NULL, 
                                  client.secret = NULL, set.headers = TRUE){
  # Finding/setting key file
  if (file.exists("~/.config/trakt/key.json")){
    keyfile <- "~/.config/trakt/key.json"
  } else if (file.exists("key.json")){
    keyfile <- "./key.json"
  } else {
    keyfile <- NULL
  }
  if (!(is.null(keyfile))){
    message(paste("Reading credentials from", keyfile))
  } else {
    message("No keyfile set/found")
  }

  # Setting v1 API key
  if (!is.null(apikey)){
    options(trakt.apikey = apikey)
  } else if (!(is.null(keyfile))){
    options(trakt.apikey = jsonlite::fromJSON(keyfile)[["apikey"]])
  } else {
    warning("Couldn't find your APIv1 key")
  }

  # Setting username (just in case)
  if (!is.null(username)){
    message("Setting trakt username to ", username)
    options(trakt.username = username)
  } else if (!(is.null(keyfile))){
    options(trakt.username = jsonlite::fromJSON(keyfile)[["username"]])
  } else {
    warning("Couldn't find your username")
  }

  # Setting v2 client id
  if (!(is.null(client.id))){
    options(trakt.client.id = client.id)
  } else if (!(is.null(keyfile))){
    options(trakt.client.id = jsonlite::fromJSON(keyfile)[["client.id"]])
  } else {
    warning("Couldn't find your client id")
  }

  # Setting v2 client secret (not used yet)
  if (!(is.null(client.secret))){
    options(trakt.client.secret = client.id)
  } else if (!(is.null(keyfile))){
    options(trakt.client.secret = jsonlite::fromJSON(keyfile)[["client.secret"]])
  } else {
    warning("Couldn't find your client secret")
  }

  # Communicate the above
  message("Please check if everything seems right:")
  message(paste("Your trakt.tv username is set to",   getOption('trakt.username')))
  message(paste("Your APIv1 key is set to",           getOption('trakt.apikey')))
  message(paste("Your APIv2 client id is set to",     getOption('trakt.client.id')))
  message("Your APIv2 client secret is set (not displayed for privacy reasons)")

  # Set the appropriate header for httr::GET
  if (set.headers){
    headers <- httr::add_headers(.headers = c("trakt-api-key"     = getOption("trakt.client.id"),
                                              "Content-Type"      = "application/json",
                                              "trakt-api-version" = 2))
    options(trakt.headers = headers)
    message("HTTP headers set, retrieve via getOption('trakt.headers')")
  }
}
