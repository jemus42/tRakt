#' Get trending movies
#'
#' \code{trakt.movies.trending} returns a list of trending movies on trakt.tv.
#' According to the API docs, it returns all movies being watched right now, where
#' movies with the most users are returned first.
#' @param limit Number of movies to return. Is coerced to \code{integer} and must be greater than 0.
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"full"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame} containing trending movies with their number of watchers, name and ids
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/trending/get-trending-movies}{the trakt API docs for further info}
#' @family movie
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movies.trending(5)
#' }
trakt.movies.trending <- function(limit = 10, extended = "min"){
  limit <- as.integer(limit)
  if (limit < 1){
    stop("Limit must be greater than zero")
  }
  ids <- NULL; movie <- NULL

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/movies/trending"
  url      <- paste0(baseURL, "?page=1&limit=", limit, "&extended=", extended)
  response <- trakt.api.call(url)

  # Spreading out ids to get a flat data.frame
  response$movie <- cbind(subset(response$movie, select = -ids), response$movie$ids)
  response       <- cbind(subset(response, select = -movie), response$movie)

  return(response)
}
