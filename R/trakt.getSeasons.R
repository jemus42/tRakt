#' Get a show's season information
#'
#' \code{trakt.getSeasons} pulls season data.
#' Get details for a show's seasons, e.g. how many seasons there are, how many epsiodes
#' each season has, and season posters.
#' See \href{http://docs.trakt.apiary.io/#introduction/extended-info} for possible values of
#' \code{extended} to customize output amount.
#' @param target The \code{slug} of the show requested
#' @param extended Defaults to \code{full,images} to get season posters. Can be
#' \code{min}, \code{images}, \code{full}, \code{full,images}
#' @param dropspecials If \code{TRUE} (default), special episodes (listed as 'season 0') are dropped
#' @return A \code{data.frame} containing season details (nested in \code{list} objects)
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/seasons/summary}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.seasons <- trakt.getSeasons("breaking-bad", extended = "min")
#' }
trakt.getSeasons <- function(target, extended = "full,images", dropspecials = TRUE){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  
  # Constructing URL
  baseURL <- "https://api-v2launch.trakt.tv/shows/"
  url     <- paste0(baseURL, target, "/", "seasons", "?extended=", extended)
  
  # Actual API call
  headers     <- getOption("trakt.headers")
  response    <- httr::GET(url, headers)
  httr::stop_for_status(response) # In case trakt fails
  response    <- httr::content(response, as = "text")
  seasons     <- jsonlite::fromJSON(response)
  
  # Data cleanup
  if (dropspecials){
    seasons     <- seasons[seasons$number != 0, ]
  }
  return(seasons)
}
