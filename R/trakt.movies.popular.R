#' Get popular movies
#'
#' \code{trakt.movies.popular} returns a list of the most popular movies on trakt.tv.
#' According to the API docs, opularity is calculated based both ratings and number of ratings.
#' @param limit Number of movies to return. Is coerced to \code{integer} and must be greater than 0.
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"full"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{data.frame} containing popular movies with their name and ids
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/popular/get-popular-movies}{the trakt API docs for further info}
#' @family movie
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movies.popular(5)
#' }
trakt.movies.popular <- function(limit = 10, extended = "min"){
  limit <- as.integer(limit)
  if (limit < 1){
    stop("Limit must be greater than zero")
  }
  ids <- NULL

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/movies/popular"
  url      <- paste0(baseURL, "?page=1&limit=", limit, "&extended=", extended)
  response <- trakt.api.call(url)

  # Spreading out ids to get a flat data.frame
  response <- cbind(subset(response, select = -ids), response$ids)

  return(response)
}
