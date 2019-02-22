#' Get a single movie's ratings
#'
#' `trakt.movie.ratings` returns a single movie's rating and distribution.
#' @param target The `id` of the movie requested. Either the `slug`
#' (e.g. `"tron-legacy-2010"`), `trakt id` or `IMDb id`
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/ratings/get-movie-ratings}{the trakt API docs for further info}
#' @family movie data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.ratings("tron-legacy-2010")
#' }
trakt.movie.ratings <- function(target) {
  trakt.ratings(type = "movies", target)
}

#' Get a single show's ratings
#'
#' `trakt.show.ratings` returns a single show's rating and distribution.
#' @param target The `id` of the show requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/ratings/get-show-ratings}{the trakt API docs for further info}
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.show.ratings("game-of-thrones")
#' }
trakt.show.ratings <- function(target) {
  trakt.ratings(type = "shows", target)
}

#' @keywords internal
trakt.ratings <- function(type, target) {
  if (length(target) > 1) {
    ret <- purrr::map_df(target, function(t) {
      trakt.ratings(type = type, target = t)
    })
    return(ret)
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "ratings")
  response <- trakt.api.call(url = url)

  tibble::tibble(
    id = target,
    type = type,
    votes = response$votes,
    rating = response$rating,
    distribution = list(unlist(response$distribution))
  )
}
