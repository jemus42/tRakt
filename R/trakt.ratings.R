#' Get show or movie user ratings
#'
#' Returns a show's or movie's rating and ratings distribution.
#' @inheritParams id_movie_show
#' @inheritParams type_shows_movies
#' @inherit return_tibble return
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/ratings/get-show-ratings}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' trakt.movies.ratings("tron-legacy-2010")
#' trakt.shows.ratings("game-of-thrones")
#' }
trakt.ratings <- function(type = c("shows", "movies"), target) {
  type <- match.arg(type)

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

#' @rdname trakt.ratings
#' @export
trakt.shows.ratings <- function(target) {
  trakt.ratings(type = "shows", target)
}

#' @rdname trakt.ratings
#' @export
trakt.movies.ratings <- function(target) {
  trakt.ratings(type = "movies", target)
}

