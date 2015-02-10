#' Search for a show
#'
#' \code{trakt.search} pulls show stats and returns it compactly.
#' 
#' Search for a show with a keyword (e.g. \code{"Breaking Bad"}) and receive basic info of the 
#' first search result. It's main use is to retrieve the tvdbid or proper show title for further use,
#' as well as receiving a quick overview of a show.
#' @param query The keyword used for the search. Should be as URL-compatible as possible.
#' @param apikey API-key used for the call. Defaults to \code{getOption("trakt.apikey")}
#' @param limit The number of results to be returned. Defaults to 1.
#' @return A \code{data.frame} containing search results
#' @export
#' @importFrom jsonlite fromJSON
#' @import httr
#' @note See \href{http://docs.trakt.apiary.io/reference/search/text-query}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad <- trakt.search("Breaking Bad")
#' }
trakt.search <- function(query){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  # Setting values required for API call
  headers  <- getOption("trakt.headers")
  query    <- as.character(query) # Just to make sure…
  query    <- URLencode(query)    # URL normalization
  url      <- paste0("https://api-v2launch.trakt.tv/search?query=", query, "&type=show")
  
  # Actual API call
  response    <- httr::GET(url, headers)
  httr::stop_for_status(response) # In case trakt fails
  response    <- httr::content(response, as = "text")
  response    <- jsonlite::fromJSON(response)
  # Try to find the closest match via basic string comparison (Could use improvement)
  stringmatch <- match(tolower(URLdecode(query)), tolower(response$show$title))
  
  # Cleanup received data, using only matched line
  if (is.na(stringmatch)){
    warning("No exact match found, using the best guess")
    show <- response[1, ]$show
  } else {
    show <- response[stringmatch, ]$show
  }
  
  return(show)
}
