#' Get users watching a movie
#'
#' \code{trakt.movie.watching} returns trakt.tv users who are watching this movie.
#' @param target The \code{id} of the movie requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame} containing user information
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/watching/get-users-watching-right-now}{the
#'  trakt API docs for further info}
#' @family movie
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.watching("tron-legacy-2010")
#' }
trakt.movie.watching <- function(target, extended = "min"){

  # Construct URL, make API call
  url      <- build_trakt_url("movies", target, "watching", extended = extended)
  response <- trakt.api.call(url = url)

  return(response)
}

#' Get users watching a show
#'
#' \code{trakt.show.watching} returns trakt.tv users who are watching this show.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame} containing user information
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/watching/get-users-watching-right-now}{the
#'  trakt API docs for further info}
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.show.watching("breaking-bad")
#' }
trakt.show.watching <- function(target, extended = "min"){

  # Construct URL, make API call
  url      <- build_trakt_url("shows", target, "watching", extended = extended)
  response <- trakt.api.call(url = url)

  return(response)
}
