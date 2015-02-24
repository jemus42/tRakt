#' Search for related movies
#'
#' \code{trakt.movies.related} returns movies related to the input movie.
#'
#' Receive a set of movies that are related to a specific movie.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @return A \code{data.frame} containing search results
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/related/get-related-movies}{the trakt API docs for further info}
#' @family movie
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' related <- trakt.movies.related(""tron-legacy-2010"")
#' }
trakt.movies.related <- function(target){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  ids <- NULL

  baseURL <- "https://api-v2launch.trakt.tv/movies"
  url     <- paste0(baseURL, "/", target, "/related")

  # Actual API call
  response <- trakt.api.call(url = url)

  # Flattening
  response <- cbind(subset(response, select = -ids), response$ids)

  return(response)
}
