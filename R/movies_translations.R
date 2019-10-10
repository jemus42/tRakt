#' Get translations for a movie, show or episode
#'
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#'
#' @examples
#' # Get all translations
#' movies_translations("193972")
#'
#' # Only get a specific language
#' movies_translations("193972", "de")
movies_translations <- function(id, languages = NULL) {
  languages <- check_filter_arg(languages, "languages")

  url <- build_trakt_url("movies", id, "translations", languages)
  response <- trakt_get(url)

  as_tibble(response)
}

#' @rdname movies_translations
#' @export
shows_translations <- function(id, languages = NULL) {
  languages <- check_filter_arg(languages, "languages")

  url <- build_trakt_url("shows", id, "translations", languages)
  response <- trakt_get(url)

  as_tibble(response)
}

#' @rdname movies_translations
#' @export
episodes_translations <- function(id, season = 1L, episode = 1L, languages = NULL) {
  languages <- check_filter_arg(languages, "languages")

  url <- build_trakt_url(
    "shows", id, "seasons", season, "episodes", episode, "translations", languages
  )
  response <- trakt_get(url)

  as_tibble(response)
}
