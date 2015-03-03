#' Search for related movies
#'
#' \code{trakt.movies.related} returns movies related to the input movie.
#'
#' Receive a set of movies that are related to a specific movie.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame} containing search results
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/related/get-related-movies}{the trakt API docs for further info}
#' @family movie
#' @family aggregate
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' related <- trakt.movies.related("tron-legacy-2010")
#' }
trakt.movies.related <- function(target, extended = "min"){

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/movies/"
  url      <- paste0(baseURL, target, "/related?extended=", extended)
  response <- trakt.api.call(url = url)

  # Flattening
  response <- cbind(response[names(response) != "ids"], response$ids)

  return(response)
}

#' Search for related shows
#'
#' \code{trakt.shows.related} returns shows related to the input show.
#'
#' Receive a set of shows that are related to a specific show.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
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
trakt.shows.related <- function(target, extended = "min"){

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/shows/"
  url      <- paste0(baseURL, target, "/related?extended=", extended)
  response <- trakt.api.call(url = url)

  # Flattening
  response <- cbind(response[names(response) != "ids"], response$ids)

  return(response)
}
