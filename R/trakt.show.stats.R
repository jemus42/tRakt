#' Get a show's summary info
#'
#' \code{trakt.show.stats} pulls show stats and returns it compactly.
#' 
#' The data includes show ratings, scrobbles, checkins, plays, comments…
#' @param target The \code{slug} or \code{tvdbid} of the show requested
#' @param apikey API-key used for the call. Defaults to \code{getOption("trakt.apikey")}
#' @return A \code{list} containing show stats
#' @export
#' @note See \href{http://trakt.tv/api-docs/show-stats}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad.stats <- trakt.show.stats("breaking-bad")
#' }
trakt.show.stats <- function(target, apikey = getOption("trakt.apikey")){
  if (is.null(apikey)){
    stop("No API key set")
  }
  baseURL  <- "http://api.trakt.tv/show/stats.json/"
  url      <- paste0(baseURL, apikey, "/", target)
  response <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")
  response <- rjson::fromJSON(response)
  return(response)
}
