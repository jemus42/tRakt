#' Get the cast and crew of a show
#'
#' \code{trakt.show.people} pulls show people data.
#'
#' Returns all cast and crew for a show, depending on how much data is available.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing \code{data.frame}s for cast and crew.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/people/get-all-people-for-a-show}{the trakt API docs for further info}
#' @family show
#' @family people
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.people <- trakt.show.people("breaking-bad")
#' }
trakt.show.people <- function(target, extended = "min"){

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/shows/"
  url      <- paste0(baseURL, target, "/people?extended=", extended)
  response <- trakt.api.call(url = url)

  # Flatten the data.frame
  response$cast  <- cbind(response$cast[names(response$cast) != "person"], response$cast$person)
  response$cast  <- cbind(response$cast[names(response$cast) != "ids"],    response$cast$ids)

  return(response)
}
