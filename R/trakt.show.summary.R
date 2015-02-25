#' Get show summary info
#'
#' \code{trakt.show.summary} pulls show summary data and returns it compactly.
#'
#' Note that setting \code{extended} to \code{min} makes this function
#' return about as much informations as \link[tRakt]{trakt.search}
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"full"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing summary info
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/summary}{the trakt API docs for further info}
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.summary_full <- trakt.show.summary("breaking-bad")
#' }
trakt.show.summary <- function(target, extended = "full"){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/shows/"
  url      <- paste0(baseURL, target, "?extended=", extended)
  response <- trakt.api.call(url = url)

  return(response)
}
