#' Get users watching a movie
#'
#' `trakt.movie.watching` returns trakt.tv users who are watching this movie.
#' @param target The `id` of the movie requested. Either the `slug`
#' (e.g. `"tron-legacy-2010"`), `trakt id` or `IMDb id`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `data.frame` containing user information
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/watching/get-users-watching-right-now}{the
#'  trakt API docs for further info}
#' @family movie data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.watching("tron-legacy-2010")
#' }
trakt.movie.watching <- function(target, extended = "min") {
  response <- trakt.watching(type = "movies", target = target, extended = extended)

  return(response)
}

#' Get users watching a show
#'
#' `trakt.show.watching` returns trakt.tv users who are watching this show.
#' @param target The `id` of the show requested. Either the `slug`
#' (e.g. `"tron-legacy-2010"`), `trakt id` or `IMDb id`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `data.frame` containing user information
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/watching/get-users-watching-right-now}{the
#'  trakt API docs for further info}
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.show.watching("breaking-bad")
#' }
trakt.show.watching <- function(target, extended = "min") {
  response <- trakt.watching(type = "shows", target = target, extended = extended)

  return(response)
}

#' @keywords internal
trakt.watching <- function(type, target, extended = "min") {
  if (length(target) > 1) {
    response <- plyr::ldply(target, function(t) {
      response <- trakt.watching(type = type, target = t, extended = extended)
      if (!is.null(response)) response$source <- t
      return(response)
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "watching", extended = extended)
  response <- trakt.api.call(url = url)

  if (identical(response, list())) {
    message(paste("Nobody watching", target))
    return(NULL)
  }

  return(response)
}
