#' Get show summary info
#'
#' \code{trakt.show.summaries} pulls show summary data and returns it compactly.
#' 
#' @param target The \code{slug} or \code{tvdbid} of the show requested
#' @param apikey API-key used for the call. 
#' Defaults to \code{getOption("trakt.apikey")}
#' @param extended Whether extended info should be provided. 
#' Defaults to \code{NULL}, can be \code{"normal"} or \code{"full"}
#' @return A \code{data.frame} containing summary info
#' @export
#' @note See \href{http://trakt.tv/api-docs/show-summaries}{the trakt API docs for further info}
#' Not to be confused with \href{http://trakt.tv/api-docs/show-summary}{show/summary}
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad.summary <- trakt.show.summary("breaking-bad")
#' }
trakt.show.summaries <- function(target, apikey = getOption("trakt.apikey"), extended = NULL){
  if (is.null(apikey)){
    stop("No API key set")
  }
  baseURL <- "http://api.trakt.tv/show/summaries.json/"
  url     <- paste0(baseURL, apikey, "/", target)
  if (!is.null(extended)){
    url   <- paste0(url, "/", extended)
  }
  response <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")
  response <- jsonlite::fromJSON(response)
  response$title <- iconv(response$title, "latin1", "UTF-8")
  return(response)
}
