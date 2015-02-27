#' Get a single movie's ratings
#'
#' \code{trakt.movie.ratings} returns a single movie's rating and distribution.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @return A \code{list} containing movie ratings and distribution
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/ratings/get-movie-ratings}{the trakt API docs for further info}
#' @family movie
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.ratings("tron-legacy-2010")
#' }
trakt.movie.ratings <- function(target){

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/movies/"
  url      <- paste0(baseURL, target, "/ratings")
  response <- trakt.api.call(url = url)

  # Flattening the distribution a little
  response$distribution        <- as.data.frame(response$distribution)
  names(response$distribution) <- 1:ncol(response$distribution)

  return(response)
}
