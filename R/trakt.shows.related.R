#' Search for related shows
#'
#' \code{trakt.shows.related} returns shows related to the input show.
#'
#' Receive a set of shows that are related to a specific show.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @return A \code{data.frame} containing search results
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/related/get-related-shows}{the trakt API docs for further info}
#' @family show
#' @family aggregate
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' related <- trakt.shows.related("game-of-thrones")
#' }
trakt.shows.related <- function(target){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  ids <- NULL

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/shows"
  url      <- paste0(baseURL, "/", target, "/related")
  response <- trakt.api.call(url = url)

  # Flattening
  response <- cbind(subset(response, select = -ids), response$ids)

  return(response)
}
