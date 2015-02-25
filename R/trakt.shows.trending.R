#' Get trending shows
#'
#' \code{trakt.shows.trending} returns a list of trending shows on trakt.tv.
#' According to the API docs, it returns all shows being watched right now, where
#' shows with the most users are returned first.
#' @param limit Number of shows to return. Is coerced to \code{integer} and must be greater than 0.
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"full"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame} containing trending shows with their name and ids
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/get-trending-shows}{the trakt API docs for further info}
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.shows.trending(5)
#' }
trakt.shows.trending <- function(limit = 10, extended = "min"){
  limit <- as.integer(limit)
  if (limit < 1){
    stop("Limit must be greater than zero")
  }
  ids <- NULL; show <- NULL

  baseURL  <- "https://api-v2launch.trakt.tv/shows/trending"
  url      <- paste0(baseURL, "?page=1&limit=", limit, "&extended=", extended)
  response <- trakt.api.call(url)

  # Spreading out ids to get a flat data.frame
  response$show <- cbind(subset(response$show, select = -ids), response$show$ids)
  response      <- cbind(subset(response, select = -show), response$show)
  return(response)
}
