#' Get a season of a show
#'
#' \code{trakt.getSeason} pulls a full season's data.
#' Similar to \link{trakt.getSeasons}, but this function returns full data for
#' a single season, i.e. all the episodes of the season.
#' @param target The \code{slug} or \code{tvdbid} of the show requested
#' @param apikey API-key used for the call. Defaults to \code{getOption("trakt.apikey")}
#' @param season The season to get. Defaults to 1. Use 0 for special episodes.
#' @return A \code{data.frame} containing all of a season's episodes
#' @export
#' @import plyr
#' @note See \href{http://trakt.tv/api-docs/show-season}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad.seasons <- trakt.getSeason("breaking-bad", 1)
#' }
trakt.getSeason <- function(target, apikey = getOption("trakt.apikey"), season = 1){
  if (is.null(apikey)){
    stop("No API key set")
  }
  baseURL            <- "http://api.trakt.tv/show/season.json/"
  url                <- paste0(baseURL, apikey, "/", target, "/", season)
  response           <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")
  show.season        <- jsonlite::fromJSON(response)

  # UTF-8 fix
  show.season$title    <- iconv(show.season$title,    "latin1", "UTF-8")
  show.season$overview <- iconv(show.season$overview, "latin1", "UTF-8")
  
  # Reorganization
  show.season$rating                <- show.season$ratings$percentage
  show.season$votes                 <- show.season$ratings$votes
  show.season$loved                 <- show.season$ratings$loved
  show.season$hated                 <- show.season$ratings$hated
  show.season                       <- show.season[!(names(show.season) %in% c("images", "ratings"))]
  show.season$firstaired.posix      <- as.POSIXct(show.season$first_aired_utc, 
                                                origin = lubridate::origin, tz = "UTC")
  show.season$firstaired.string     <- format(show.season$firstaired.posix, "%F")  
  show.season$year                  <- lubridate::year(show.season$firstaired.posix)

  return(show.season)
}
