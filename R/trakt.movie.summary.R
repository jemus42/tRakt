#' Get a single movie's details
#'
#' \code{trakt.movie.summary} returns a single movie's summary information.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"full"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing movie information
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/summary/get-a-movie}{the trakt API docs for further info}
#' @family movie
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.summary("tron-legacy-2010")
#' }
trakt.movie.summary <- function(target, extended = "min"){

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/movies/"
  url      <- paste0(baseURL, target, "?extended=", extended)
  response <- trakt.api.call(url = url)

  return(response)
}
