#' Get the cast and crew of a movie
#'
#' \code{trakt.movie.people} pulls movie people data.
#'
#' Returns all cast and crew for a movie, depending on how much data is available.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing \code{data.frame}s for cast and crew.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/movies/people/get-all-people-for-a-movie}{the trakt API docs for further info}
#' @family movie
#' @family people
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' tron.people <- trakt.movie.people("tron-legacy-2010")
#' }
trakt.movie.people <- function(target, extended = "min"){

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/movies/"
  url      <- paste0(baseURL, target, "/people?extended=", extended)
  response <- trakt.api.call(url = url)

  # Flatten the data.frame
  response$cast  <- cbind(response$cast[names(response$cast) != "person"], response$cast$person)
  response$cast  <- cbind(response$cast[names(response$cast) != "ids"],    response$cast$ids)

  return(response)
}
