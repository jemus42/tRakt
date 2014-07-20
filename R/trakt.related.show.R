#' Search for related shows
#'
#' \code{trakt.related.show} returns related shows to the search query.
#' 
#' Search for related shows to the show you specified.
#' @param target The show's tvdb id to be used.
#' @param apikey API-key used for the call. Defaults to \code{getOption("trakt.apikey")}
#' @return A \code{data.frame} containing search results
#' @export
#' @note See \href{http://trakt.tv/api-docs/show-related}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' related <- trakt.related.show(78874)
#' }
trakt.related.show <- function(target, apikey = getOption("trakt.apikey")){
  if (is.null(apikey)){
    stop("No API key set")
  }
  baseURL  <- "http://api.trakt.tv/show/related.json/"
  url      <- paste0(baseURL, "/", apikey, "/", target)
  response <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")
  response <- jsonlite::fromJSON(response)

  response$title    <- iconv(response$title,    "latin1", "UTF-8") 
  response$overview <- iconv(response$overview, "latin1", "UTF-8") 
  return(response)
}
