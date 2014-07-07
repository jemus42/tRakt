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
#' @note See \href{http://trakt.tv/api-docs/search-shows}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad <- trakt.search("Breaking Bad")
#' }
trakt.search <- function(query, apikey = getOption("trakt.apikey"), limit = 1){
  if (is.null(apikey)){
    stop("No API key set")
  }
  query    <- as.character(query) # Just to make sure…
  query    <- gsub(" ", "+", query) # _Not_ perfect URL normalization
  url      <- paste0("http://api.trakt.tv/search/shows.json/", apikey, "?query=")
  query    <- paste0(url, query, "&limit=", limit)
  response <- httr::content(httr::GET(query), as = "text", encoding = "UTF-8")
  response <- rjson::fromJSON(response)
  response <- response[[1]]
  return(response)
}
