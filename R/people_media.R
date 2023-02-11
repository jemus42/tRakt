#' Get a single person's movie or show credits
#'
#' Returns all movies or shows where this person is in the cast or crew.
#' @name people_media
#' @details
#' Note that as of 2019-09-30, there are two representations of `character[s]` and `job[s]`:
#' One is a regular character variable, and the other is a list-column. The singular is
#' [deprecated and only included for compatibility reasons](https://github.com/trakt/api-help/issues/74).
#'
#' @inheritParams trakt_api_common_parameters
#' @return A `list` of one or more [tibbles][tibble::tibble-package] for `cast`
#' and `crew`. The latter `tibble` objects are as flat as possible.
#' @seealso [media_people], for the other direction: Media that has people.
#' @examples
#' \dontrun{
#' people_movies("christopher-nolan")
#'
#' people_shows("kit-harington")
#' }
NULL

#' @keywords internal
#' @noRd
#' @importFrom rlang has_name
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
#' @importFrom purrr is_empty
people_media <- function(type = c("shows", "movies"), id,
                         extended = c("min", "full")) {
  extended <- match.arg(extended)
  type <- match.arg(type)

  # Construct URL, make API call
  url <- build_trakt_url("people", id, type, extended = extended)
  response <- trakt_get(url = url)

  if (identical(response, list(cast = list()))) {
    return(tibble())
  }

  if (type == "shows") {
    if (has_name(response, "cast") && !is_empty(response$cast)) {
      response$cast <- response$cast$show %>%
        unpack_show() %>%
        bind_cols(
          response$cast %>%
            select(-"show")
        ) %>%
        as_tibble()
    }
    if (has_name(response, "crew") && !is_empty(response$crew)) {
      response$crew <- unpack_crew_sections(response$crew, type = "shows")
    }
  }
  if (type == "movies") {
    if (has_name(response, "cast") && !is_empty(response$cast)) {
      response$cast <- response$cast %>%
        unpack_movie() %>%
        as_tibble()
    }
    if (has_name(response, "crew") && !is_empty(response$crew)) {
      response$crew <- unpack_crew_sections(response$crew, type = "movies")
    }
  }

  response
}


#' @rdname people_media
#' @eval apiurl("people", "movies")
#' @family movie data
#' @family people data
#' @export
people_movies <- function(id, extended = c("min", "full")) {
  people_media(type = "movies", id = id, extended = extended)
}

#' @rdname people_media
#' @eval apiurl("people", "shows")
#' @family show data
#' @family people data
#' @export
people_shows <- function(id, extended = c("min", "full")) {
  people_media(type = "shows", id = id, extended = extended)
}
