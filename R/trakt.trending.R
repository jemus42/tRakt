#' Get trending movies
#'
#' `trakt.movies.trending` returns a list of trending movies on trakt.tv.
#' According to the API docs, it returns all movies being watched right now, where
#' movies with the most users are returned first.
#' @param limit Number of movies to return. Is coerced to `integer` and must be greater than 0.
#' @param page Page to return (default is `1`)
#' for \href{http://docs.trakt.apiary.io/#introduction/pagination}{pagination}.
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `data.frame` containing trending movies with their number of watchers, name and ids
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/trending/get-trending-movies}{the trakt API docs for further info}
#' @family movie data
#' @family aggregated data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movies.trending(5)
#' }
trakt.movies.trending <- function(limit = 10, page = 1, extended = "min") {
  response <- trakt.trending("movies", limit = limit, page = page, extended = extended)

  return(response)
}

#' Get trending shows
#'
#' `trakt.shows.trending` returns a list of trending shows on trakt.tv.
#' According to the API docs, it returns all shows being watched right now, where
#' shows with the most users are returned first.
#' @param limit Number of shows to return. Is coerced to `integer` and must be greater than 0.
#' @param page Page to return (default is `1`)
#' for \href{http://docs.trakt.apiary.io/#introduction/pagination}{pagination}.
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `data.frame` containing trending shows with their name and ids
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/get-trending-shows}{the trakt API docs for further info}
#' @family show data
#' @family aggregated data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.shows.trending(5)
#' }
trakt.shows.trending <- function(limit = 10, page = 1, extended = "min") {
  response <- trakt.trending("shows", limit = limit, page = page, extended = extended)

  return(response)
}

#' @keywords internal
trakt.trending <- function(type, limit = 10, page = 1, extended = "min") {
  limit <- as.integer(limit)
  page <- as.integer(page)
  if (limit < 1 | page < 1) {
    stop("Limit and page must be greater than zero")
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, "trending", page = page, limit = limit, extended = extended)
  response <- trakt.api.call(url)

  if (type == "shows") {
    response <- cbind(response[names(response) != "show"], response$show)
    response$show <- cbind(response$show[names(response$show) != "ids"], response$show$ids)
  } else if (type == "movies") {
    response$movie <- cbind(response$movie[names(response$movie) != "ids"], response$movie$ids)
    response <- cbind(response[names(response) != "movie"], response$movie)
  }
  response <- convert_datetime(response)

  tibble::remove_rownames(tibble::as_tibble(response))
}
