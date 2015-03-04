#' Get a single movie's release details
#'
#' \code{trakt.movie.releases} returns a single movie's release information,
#' including the release date, country code (two letter, e.g. \code{us}), and
#' the certification (e.g. \code{PG}).
#' @param target The \code{id} of the movie requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}.
#' @param country Optional two letter country code.
#' @return A \code{data.frame} containing movie release dates and certification.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/releases/get-all-movie-releases}{the
#'  trakt API docs for further info}
#' @family movie
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.releases("tron-legacy-2010")
#' }
trakt.movie.releases <- function(target, country = NULL) {

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/movies/"
  url      <- paste0(baseURL, target, "/releases/", country)
  response <- trakt.api.call(url = url)

  return(response)
}
