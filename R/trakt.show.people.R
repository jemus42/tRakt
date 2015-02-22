#' Get the cast and crew of a show
#'
#' \code{trakt.show.people} pulls show people data.
#'
#' Returns all cast and crew for a show.
#' @param target The \code{slug} of the show requested, e.g. \code{game-of-thrones}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @return A \code{list} containing people info
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/people/get-all-people-for-a-show}{the trakt API docs for further info}
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.people <- trakt.show.people("breaking-bad")
#' }
trakt.show.people <- function(target, extended = "min"){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  # Please R CMD check
  person <- NULL
  ids    <- NULL

  # Constructing URL
  baseURL <- "https://api-v2launch.trakt.tv/shows"
  url     <- paste0(baseURL, "/", target, "/people")
  url     <- paste0(url, "?extended=", extended)

  # Actual API call
  response <- trakt.api.call(url = url)

  # Flatten the data.frame
  response$cast  <- cbind(subset(response$cast, select = -person), response$cast$person)
  response$cast  <- cbind(subset(response$cast, select = -ids), response$cast$ids)
}
