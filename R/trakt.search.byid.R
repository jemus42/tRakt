#' Lookup a show via id
#'
#' \code{trakt.search.byid} pulls show stats and returns it compactly.
#'
#' @param id The id used for the search. Will be \code{URLencode}'d.
#' @param id_type The type of \code{id}. Defaults to \code{trakt-show}, can be
#' \code{trakt-movie}, \code{trakt-show}, \code{trakt-episode}, \code{imdb},
#' \code{tmdb}, \code{tvdb}, \code{tvrage}
#' @return A \code{data.frame} containing a single search result. Hopefully the one you wanted.
#' If no result is found, the return value is \code{list(error = "Nothing found")} and a \code{warning}
#' @export
#' @importFrom jsonlite fromJSON
#' @import httr
#' @note See \href{http://docs.trakt.apiary.io/reference/search/id-lookup/get-id-lookup-results}{the trakt API docs for further info}
#' @family API, search
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad <- trakt.search.byid(1388, "trakt-show")
#' }
trakt.search.byid <- function(id, id_type = "trakt-show"){

  # Construct URL, make API call
  id       <- as.character(id)
  id       <- URLencode(id)    # URL normalization
  baseURL  <- "https://api-v2launch.trakt.tv/search"
  url      <- paste0(baseURL, "?id_type=", id_type, "&id=", id)
  response <- trakt.api.call(url = url)

  # Check if response is empty (nothing found)
  if (identical(response, list())){
    warning("No result, sorry.")
    return(list(error = "Nothing found"))
  }
  show <- response$show
  return(show)
}
