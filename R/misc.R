#' Easy episode id padding
#' 
#' Simple function to ease the creation of \code{sXXeYY} episode ids.
#' @param s Input season number, coerced to \code{character}.
#' @param e Input episode number, coerced to \code{character}.
#' @param width The length of the padding. Defaults to 2.
#' @return A \code{character} in standard \code{sXXeYY} format
#' @export
#' @note See \href{http://trakt.tv/api-docs/show-stats}{the trakt API docs for further info}
#' @examples
#' pad(2, 4)
pad <- function(s = "0", e = "0", width = 2){
  # Simple function to ease sXXeXX epid format creation
  s <- as.character(s)
  e <- as.character(e)
  season <- sapply(s, function(x){
              if (nchar(x, "width") < width){
                missing <- width - nchar(x, "width")
                x.pad   <- paste0(rep("0", missing), x)
                return(x.pad)
              } else {
                return(x)
              }
            })
  episode <- sapply(e, function(x){
                if (nchar(x, "width") < width){
                  missing <- width - nchar(x, "width")
                  x.pad   <- paste0(rep("0", missing), x)
                  return(x.pad)
                } else {
                  return(x)
                }
              })
  epstring <- paste0("s", season, "e", episode)
  return(epstring)
}

#' Get info from a show URL
#'
#' \code{getNameFromURL} extracts some info from a show URL
#' @param url Input URL. must be a \code{character}, but not a valid URL.
#' @param epid Whether the episode ID (\code{sXXeYY} format) should be extracted. 
#' Defaults to \code{FALSE}.
#' @param getslug Whether the \code{slug} should be extracted. Defaults to \code{FALSE}.
#' @return A \code{list} containing at least the show name.
#' @export
#' @importFrom stringr str_split
#' @note This is pointless.
#' @examples
#' \dontrun{
#' getNameFromURL("http://trakt.tv/show/fargo/season/1/episode/2", T, T)
#' getNameFromURL("http://trakt.tv/show/breaking-bad", T, F)
#' }
getNameFromURL <- function(url, epid = FALSE, getslug = FALSE){
  showname <- stringr::str_split(url, "/")[[1]][5]
  ret <- list("show" = showname)
  if (epid){
    season   <- stringr::str_split(url, "/")[[1]][7]
    episode  <- stringr::str_split(url, "/")[[1]][9]
    if(is.na(season) | is.na(episode)){
      ret$epid <- NA
    } else{
      epid     <- pad(season, episode)
      ret$epid <- epid 
    }
  }
  if (getslug){
    slug <- stringr::str_split(url, "/", 5)
    ret$slug <- slug[[1]][5]
  }
  return(ret)
  # Most of this is pointless.
}

#' [Deprecated] Initialize an empty episode dataset
#'
#' \code{initializeEpisodes} uses the show season info provided by \link{trakt.getSeasons}
#' to initialize a \code{data.frame} with a row for each episode of the show.
#' 
#' This function will be removed in tRakt v1.0.0
#' @param show.seasons Show seasons dataset, normally provided by \link{trakt.getSeasons}
#' @return A \code{data.frame} containing episode placeholders.
#' @export
#' @note This is not a regular trakt-function, hence the "trakt."-prefix is omitted.
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad.seasons <- trakt.getSeasons("breaking-bad")
#' breakingbad.episodes <- initializeEpisodes(breakingbad.seasons)
#' } 
initializeEpisodes <- function(show.seasons = NULL){
  if (is.null(show.seasons)){
    stop("Wat")
  }
  show.episodes       <- plyr::ddply(show.seasons, .(season), plyr::summarize, episode = 1:episodes)
  show.episodes$epnum <- 1:nrow(show.episodes)
  
  # Add epid in sXXeYY format, requires pad() from helpers.R
  show.episodes      <- transform(show.episodes, epid = pad(season, episode))
  show.episodes$epid <- factor(show.episodes$epid, ordered = TRUE)
  return(show.episodes)
}

#' Easy string pasting
#' 
#' \code{\%+\%} is an infix version of \code{paste0} or \code{paste(…, sep="")}
#' 
#' @param a,b Character strings to paste together
#' @return A \code{character} string.
#' @export
#' @note Blatantly copied from \href{http://adv-r.had.co.nz/Functions.html#infix-functions}{Hadley Wickham}
#' @examples
#' \dontrun{
#' "string one" %+% " string two"
#' }
`%+%` <- function(a, b){
  if (is.null(a) && is.null(b)) return(NULL)
  if (is.null(a)) return(b)
  if (is.null(b)) return(a)
  ret <- paste(a, b, sep = "")
  return(ret)
}

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
