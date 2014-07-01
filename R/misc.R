#' Easy episode id padding
#'
#' \code{pad} pulls show stats and returns it compactly.
#' 
#' Simple function to ease the creation of \code{sXXeYY} episode ids.
#' @param x Input episode/season number, coerced to \code{character}.
#' @param width The length of the padding. Defaults to 2.
#' @return A \code{character} in standard \code{sXXeYY} format
#' @export
#' @note See \href{http://trakt.tv/api-docs/show-stats}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' season  <- 5
#' episode <- 1
#' paste0("s", pad(season), "e", pad(episode))
#' 
#' pad(c(1,2,3))
#' }
pad <- function(x, width = 2){
  # Simple function to ease sXXeXX epid format creation
  x <- as.character(x)
  sapply(x, function(x){
    if (nchar(x, "width") < width){
      missing <- width - nchar(x, "width")
      x.pad   <- paste0(rep("0", missing), x)
      return(x.pad)
    } else {
      return(x)
    }
  })
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
      epid     <- paste0("s", pad(season), "e", pad(episode))
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
#' @return A \code{data.frame} containing detailed episode data.
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
  show.episodes      <- transform(show.episodes, epid = paste0("s", pad(season), "e", pad(episode)))
  show.episodes$epid <- factor(show.episodes$epid, ordered = TRUE)
  return(show.episodes)
}
