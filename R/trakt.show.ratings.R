#' Get a single show's ratings
#'
#' \code{trakt.show.ratings} returns a single show's rating and distribution.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @return A \code{list} containing show ratings and distribution
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/ratings/get-show-ratings}{the trakt API docs for further info}
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.show.ratings("game-of-thrones")
#' }
trakt.show.ratings <- function(target){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }

  baseURL  <- "https://api-v2launch.trakt.tv/shows/"
  url      <- paste0(baseURL, target, "/ratings")
  response <- trakt.api.call(url = url)

  # Flattening the distribution a little
  response$distribution        <- as.data.frame(response$distribution)
  names(response$distribution) <- 1:ncol(response$distribution)

  return(response)
}
