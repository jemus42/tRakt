#' Get a show's season information
#'
#' \code{trakt.getSeasons} pulls season data.
#' Get details for a show's seasons, e.g. how many seasons there are, how many epsiodes
#' each season has, and seaosn posters. Unfortunately, trakt does not offer per-season ratings.
#' @param target The \code{slug} or \code{tvdbid} of the show requested
#' @param apikey API-key used for the call. Defaults to \code{getOption("trakt.apikey")}
#' @param dropspecials If \code{TRUE}, special episodes (listed as 'season 0') are ignored. This is the default.
#' @return A \code{data.frame} containing season details
#' @export
#' @import plyr
#' @note See \href{http://trakt.tv/api-docs/show-season}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad.seasons <- trakt.getSeasons("breaking-bad")
#' }
trakt.getSeasons <- function(target, dropspecials = TRUE, apikey = getOption("trakt.apikey")){
  if (is.null(apikey)){
    stop("No API key set")
  }
  baseURL            <- "http://api.trakt.tv/show/seasons.json/"
  url                <- paste0(baseURL, apikey, "/", target)
  show.seasons       <- jsonlite::fromJSON(url)
  if (dropspecials){
    show.seasons     <- show.seasons[show.seasons$season != 0, ] 
  }
  show.seasons       <- show.seasons[!(names(show.seasons) %in% c("url", "images"))]
  show.seasons       <- plyr::arrange(show.seasons, season)
  return(show.seasons)
}
