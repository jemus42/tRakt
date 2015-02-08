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

#' Initialize an empty episode dataset
#'
#' \code{initializeEpisodes} uses the show season info provided by \link{trakt.getSeasons}
#' to initialize a \code{data.frame} with a row for each episode of the show.
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

#' Get the trakt.tv credentials
#' 
#' \code{get_trakt_credentials} searches for your credentials and stores them 
#' in the appropriate \code{option} variables
#' 
#' @param apikey Optional. Directly set your API key
#' @param username Optional. Also set your trakt.tv username (Not used yet)
#' @return Nothing
#' @export
#' @note Not yet implemented for the APIv2
#' @examples
#' \dontrun{
#' get_trakt_credentials()
#' }
get_trakt_credentials <- function(apikey = NULL, username = NULL){
  if (!is.null(apikey)){
    message("Setting trakt apikey to ", apikey)
    options(trakt.apikey = apikey)
  }
  if (!is.null(username)){
    message("Setting trakt username to ", username)
    options(trakt.username = username)
  } 
  if (file.exists("~/.config/trakt/key.txt")){
    message("Reading from ~/.config/trakt/key.txt")
    options(trakt.apikey = read.table("~/config/trakt/key.txt", stringsAsFactors = F)[1,1])
  } else if (file.exists("~/.config/trakt/key.json")){
    message("Reading from ~/.config/trakt/key.json")
    options(trakt.apikey = jsonlite::fromJSON("~/.config/trakt/key.json")$apikey)
  } else if (file.exists("key.json")){
    message("Reading API key from key.json")
    options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
  } else if (file.exists("key.txt")){
    message("Reading API key from key.txt")
    options(trakt.apikey = read.table("key.txt", stringsAsFactors = F)[1,1])
  } 
  if (is.null(getOption("trakt.apikey"))){
    stop("You need to set an API key but I don't know where to get it :(")
  }
}
