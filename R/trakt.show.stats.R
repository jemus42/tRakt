#' [Defunct] Get a show's summary info
#'
#' DEFUNCT as of 2015-02-11,
#' see \href{http://docs.trakt.apiary.io/reference/shows/stats/get-show-stats}{their API docs}
#'
#' \code{trakt.show.stats} pulls show stats and returns it compactly.
#' The data includes show ratings, scrobbles, checkins, plays, comments…
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing show stats
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/stats}{the trakt API docs for further info}
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.stats <- trakt.show.stats("breaking-bad")
#' }
trakt.show.stats <- function(target, extended = "min"){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }

  # Construct URL, make API call
  baseURL <- "https://api-v2launch.trakt.tv/shows"
  url     <- paste0(baseURL, "/", target, "/stats")
  url     <- paste0(url, "?extended=", extended)
  response <- trakt.api.call(url = url)
  
  return(response)
}
