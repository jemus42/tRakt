#' [Defunct] Get a show's summary info
#'
#' DEFUNCT as of 2015-02-11, 
#' see \href{http://docs.trakt.apiary.io/reference/shows/stats/get-show-stats}{their API docs} 
#' 
#' \code{trakt.show.stats} pulls show stats and returns it compactly.
#' The data includes show ratings, scrobbles, checkins, plays, comments…
#' @param target The \code{slug} of the show requested
#' @param extended Whether extended info should be provided. 
#' Defaults to \code{"full"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing show stats
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/stats}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.stats <- trakt.show.stats("breaking-bad")
#' }
trakt.show.stats <- function(target){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  
  # Constructing URL
  baseURL <- "https://api-v2launch.trakt.tv/shows"
  url     <- paste0(baseURL, "/", target, "/stats")
  url     <- paste0(url, "?extended=", extended)
  
  # Actual API call
  response <- trakt.api.call(url = url)
  return(response)
}
