#' Get popular shows
#'
#' \code{trakt.shows.popular} returns a list of the most popular shows on trakt.tv.
#' According to the API docs, opularity is calculated based both ratings and number of ratings.
#' @param limit Number of shows to return. Is coerced to \code{integer} and must be greater than 0.
#' @return A \code{data.frame} containing popular shows with their name and ids
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/get-popular-shows}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.shows.popular(5)
#' }
trakt.shows.popular <- function(limit = 10){
  limit <- as.integer(limit)
  if (limit < 1){
    stop("Limit must be greater than zero")
  }
  baseURL  <- "https://api-v2launch.trakt.tv/shows/popular"
  url      <- paste0(baseURL, "?page=1&limit=", limit)
  response <- trakt.api.call(url)
  
  # Spreading out ids to get a flat data.frame
  names(response$ids) <- paste0("id.", names(response$ids))
  response            <- cbind(subset(response, select = -ids), response$ids)
  
  return(response)
}
