#' Get translations for a movie, show or episode
#'
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#'
#' @return A [tibble()][tibble::tibble-package].
#' @export
#'
#' @examples
#' # Get all translations
#' movies_translations("193972")
#'
#' # Only get a specific language
#' movies_translations("193972", "de")
movies_translations <- function(id, language = NULL) {

  language <- check_filter_arg(language, "languages")

  url <- build_trakt_url("movies", id, "translations", language)
  response <- trakt_get(url)

  as_tibble(response)
}

#' @rdname movies_translations
#' @export
shows_translations <- function(id, language = NULL) {

  language <- check_filter_arg(language, "languages")

  url <- build_trakt_url("shows", id, "translations", language)
  response <- trakt_get(url)

  as_tibble(response)
}

#' @rdname movies_translations
#' @export
episodes_translations <- function(id, season = 1L, episode = 1L, language = NULL) {

  language <- check_filter_arg(language, "languages")

  url <- build_trakt_url(
    "shows", id, "seasons", season, "episodes", episode, "translations", language
  )
  response <- trakt_get(url)

  as_tibble(response)
}
