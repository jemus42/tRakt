#' Get trending movies
#'
#' \code{trakt.movies.trending} returns a list of trending movies on trakt.tv.
#' According to the API docs, it returns all movies being watched right now, where
#' movies with the most users are returned first.
#' @param limit Number of movies to return. Is coerced to \code{integer} and must be greater than 0.
#' @param page Page to return (default is \code{1})
#' for \href{http://docs.trakt.apiary.io/#introduction/pagination}{pagination}.
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"full"}, can either be \code{"min"} or \code{"full"}
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
  baseURL  <- "https://api-v2launch.trakt.tv/movies/trending"
  url      <- paste0(baseURL, "?page=", page, "&limit=", limit, "&extended=", extended)
  response <- trakt.api.call(url)

  # Spreading out ids to get a flat data.frame
  response$movie <- cbind(response$movie[names(response$movie) != "ids"], response$movie$ids)
  response       <- cbind(response[names(response) != "movie"], response$movie)
  response       <- convert_datetime(response)

  return(response)
}
