#' Get a single movie's ratings
#'
#' `trakt.movie.ratings` returns a single movie's rating and distribution.
#' @param target The `id` of the movie requested. Either the `slug`
#' (e.g. `"tron-legacy-2010"`), `trakt id` or `IMDb id`
#' @return A `list` containing movie ratings and distribution
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/ratings/get-movie-ratings}{the trakt API docs for further info}
#' @family movie data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.ratings("tron-legacy-2010")
#' }
trakt.movie.ratings <- function(target) {
  response <- trakt.ratings(type = "movies", target)

  return(response)
}

#' Get a single show's ratings
#'
#' `trakt.show.ratings` returns a single show's rating and distribution.
#' @param target The `id` of the show requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`
#' @return A `list` containing show ratings and distribution
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/ratings/get-show-ratings}{the trakt API docs for further info}
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.show.ratings("game-of-thrones")
#' }
trakt.show.ratings <- function(target) {
  response <- trakt.ratings(type = "shows", target)

  return(response)
}

#' @keywords internal
trakt.ratings <- function(type, target) {
  if (length(target) > 1) {
    response <- purrr::map(target, function(t) {
      response <- trakt.ratings(type = type, target = t)
      ratings <- response[c("rating", "votes")]
      ratings$source <- t
      dist <- response$distribution
      dist$source <- t
      response <- list(ratings, dist)
      names(response) <- c("general", "distribution")
      return(response)
    })
    names(response) <- target
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "ratings")
  response <- trakt.api.call(url = url)

  # Flattening the distribution a little
  response$distribution <- as.data.frame(response$distribution)
  names(response$distribution) <- 1:ncol(response$distribution)

  # Flattening to data.frame
  temp <- as.data.frame(response[names(response) != "distribution"])
  temp$distribution <- I(response$distribution)
  response <- temp

  return(response)
}
