#' Get trending movies
#'
#' \code{trakt.movies.trending} returns a list of trending movies on trakt.tv.
#' According to the API docs, it returns all movies being watched right now, where
#' movies with the most users are returned first.
#' @param limit Number of movies to return. Is coerced to \code{integer} and must be greater than 0.
#' @param page Page to return (default is \code{1})
#' for \href{http://docs.trakt.apiary.io/#introduction/pagination}{pagination}.
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame} containing trending movies with their number of watchers, name and ids
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/trending/get-trending-movies}{the trakt API docs for further info}
#' @family movie
#' @family aggregate
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movies.trending(5)
#' }
trakt.movies.trending <- function(limit = 10, page = 1, extended = "min"){
  limit <- as.integer(limit)
  page  <- as.integer(page)
  if (limit < 1 | page < 1){
    stop("Limit and page must be greater than zero")
  }

  # Construct URL, make API call
  url      <- build_trakt_url("movies", "trending", page = page, limit = limit, extended = extended)
  response <- trakt.api.call(url)

  # Spreading out ids to get a flat data.frame
  response$movie <- cbind(response$movie[names(response$movie) != "ids"], response$movie$ids)
  response       <- cbind(response[names(response) != "movie"], response$movie)
  response       <- convert_datetime(response)

  return(response)
}

#' Get trending shows
#'
#' \code{trakt.shows.trending} returns a list of trending shows on trakt.tv.
#' According to the API docs, it returns all shows being watched right now, where
#' shows with the most users are returned first.
#' @param limit Number of shows to return. Is coerced to \code{integer} and must be greater than 0.
#' @param page Page to return (default is \code{1})
#' for \href{http://docs.trakt.apiary.io/#introduction/pagination}{pagination}.
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame} containing trending shows with their name and ids
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/get-trending-shows}{the trakt API docs for further info}
#' @family show
#' @family aggregate
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.shows.trending(5)
#' }
trakt.shows.trending <- function(limit = 10, page = 1, extended = "min"){
  limit <- as.integer(limit)
  page  <- as.integer(page)
  if (limit < 1 | page < 1){
    stop("Limit and page must be greater than zero")
  }

  # Construct URL, make API call
  url      <- build_trakt_url("shows", "trending", page = page, limit = limit, extended = extended)
  response <- trakt.api.call(url)

  # Spreading out ids to get a flat data.frame
  response$show <- cbind(response$show[names(response$show) != "ids"], response$show$ids)
  response      <- cbind(response[names(response) != "show"], response$show)
  response      <- convert_datetime(response)
  return(response)
}
