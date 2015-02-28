#' Get a show's season information
#'
#' \code{trakt.getSeasons} pulls season data.
#' Get details for a show's seasons, e.g. how many seasons there are, how many epsiodes
#' each season has, and season posters.
#' See \href{http://docs.trakt.apiary.io/#introduction/extended-info}{the API docs} for possible values of
#' \code{extended} to customize output amount.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @param extended Use \code{full,images} to get season posters. Can be
#' \code{min} (default), \code{images}, \code{full}, \code{full,images}
#' @param dropspecials If \code{TRUE} (default), special episodes (listed as 'season 0') are dropped
#' @return A \code{data.frame} containing season details (nested in \code{list} objects)
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/seasons/summary}{the trakt API docs}
#' for further info
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.seasons <- trakt.getSeasons("breaking-bad", extended = "min")
#' }
trakt.getSeasons <- function(target, extended = "min", dropspecials = TRUE){

  # Construct URL, make API call
  baseURL <- "https://api-v2launch.trakt.tv/shows/"
  url     <- paste0(baseURL, target, "/", "seasons", "?extended=", extended)
  seasons <- trakt.api.call(url = url)

  # Data cleanup
  if (dropspecials){
    seasons <- seasons[seasons$number != 0, ]
  }
  # Reorganization
  names(seasons) <- sub("number", "season", names(seasons))
  return(seasons)
}
