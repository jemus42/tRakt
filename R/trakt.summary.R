#' Get show or movie summary info
#'
#' Note that setting `extended` to `min` makes this function
#' return about as much informations as \link[tRakt]{trakt.search}
#' @inheritParams id_movie_show
#' @inheritParams extended_info
#' @inheritParams type_shows_movies
#' @inherit return_tibble return
#' @family summary data
#' @export
#' @importFrom purrr map_df
#' @importFrom purrr flatten_df
#' @importFrom tibble has_name
#' @examples
#' \dontrun{
#' # Minimal info by default
#' trakt.shows.summary("breaking-bad")
#'
#' # More information
#' trakt.shows.summary("breaking-bad", extended = "full")
#'
#' # Info for multiple movies
#' trakt.movies.summary(c("inception-2010", "the-dark-knight-2008"), extended = "full")
#' }
trakt.media.summary <- function(type, target, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      trakt.media.summary(type = type, target = t, extended = extended)
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, extended = extended)
  response <- trakt.api.call(url = url)

  if (tibble::has_name(response, "airs")) {
    names(response$airs) <- paste0("airs_", names(response$airs))
  }

  if (extended == "full") {
    genres <- list(response$genres)
    transl <- list(response$available_translations)

    response$genres <- NULL
    response$available_translations <- NULL

    response <- flatten_df(response)

    response$genres <- genres
    response$available_translations <- transl
  } else {
    response <- flatten_df(response)
  }

  response
}

# Derived ----

#' @rdname trakt.media.summary
#' @export
trakt.movies.summary <- function(target, extended = c("min", "full")) {
  trakt.media.summary(type = "movies", target = target, extended = extended)
}

#' @rdname trakt.media.summary
#' @export
trakt.shows.summary <- function(target, extended = c("min", "full")) {
  trakt.media.summary(type = "shows", target = target, extended = extended)
}
