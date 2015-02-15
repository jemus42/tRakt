#' Search for related shows
#'
#' \code{trakt.show.related} returns related shows to the search query.
#' 
#' Search for related shows to the show you specified.
#' @param target The show's \code{slug} to be used.
#' @return A \code{data.frame} containing search results
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/related/get-related-shows}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' related <- trakt.show.related("game-of-thrones")
#' }
trakt.show.related <- function(target){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  baseURL  <- "https://api-v2launch.trakt.tv/shows"
  url      <- paste0(baseURL, "/", target, "/related")
  
  # Actual API call
  response <- trakt.api.call(url = url)

  return(response)
}
