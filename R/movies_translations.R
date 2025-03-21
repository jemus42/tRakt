#' Get translations for a movie, show or episode
#'
#' @name media_translations
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "translations")
#' @family movie data
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

#' @rdname media_translations
#' @eval apiurl("shows", "translations")
#' @family show data
#' @export
shows_translations <- function(id, languages = NULL) {
  languages <- check_filter_arg(languages, "languages")

  url <- build_trakt_url("shows", id, "translations", languages)
  response <- trakt_get(url)

  as_tibble(response)
}

#' @rdname media_translations
#' @eval apiurl("episodes", "translations")
#' @family episode data
#' @export
episodes_translations <- function(id, season = 1L, episode = 1L, languages = NULL) {
  languages <- check_filter_arg(languages, "languages")

  url <- build_trakt_url(
    "shows",
    id,
    "seasons",
    season,
    "episodes",
    episode,
    "translations",
    languages
  )
  response <- trakt_get(url)

  as_tibble(response)
}
