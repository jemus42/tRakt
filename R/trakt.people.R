#' Get a single person's details
#'
#' Get a single person's details, like their various IDs. If `extended` is `"full"`,
#' there will also be biographical data if available.
#' @inheritParams id_person
#' @inheritParams extended_info
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @importFrom purrr flatten_df
#' @importFrom purrr modify_if
#' @importFrom purrr map_df
#' @family people data
#' @examples
#' \dontrun{
#' person <- trakt.people.summary("bryan-cranston", "min")
#'
#' more_people <- trakt.people.summary(c("kit-harington", "emilia-clarke"))
#' }
trakt.people.summary <- function(target, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(target) > 1) {
    response <- purrr::map_df(target, function(target) {
      trakt.people.summary(target = target, extended = extended)
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url("people", target, extended = extended)
  response <- trakt.api.call(url = url)

  # Substitute NULLs with explicit NAs and flatten IDs
  response$ids <- purrr::modify_if(response$ids, is.null,
                                   function(x) return(NA_character_))
  response <- purrr::modify_if(response, is.null,
                               function(x) return(NA_character_))
  response <- purrr::flatten_df(response)

  response
}

# People that have media ----

#' Get a single person's movie or show credits
#'
#' Returns all movies or shows where this person is in the cast or crew.
#' @inheritParams id_person
#' @inheritParams type_shows_movies
#' @inheritParams extended_info
#' @return A `list`.
#' @export
#' @family people data
#' @seealso [trakt.media.people], for the other direction: Media that has people.
#' @examples
#' \dontrun{
#' trakt.people.movies("bryan-cranston")
#' }
trakt.people.media <- function(type = c("shows", "movies"), target,
                               extended = c("min", "full")) {
  extended <- match.arg(extended)
  type <- match.arg(type)

  # Construct URL, make API call
  url <- build_trakt_url("people", target, type, extended = extended)
  trakt.api.call(url = url)
}

#' @rdname trakt.people.media
#' @export
trakt.people.movies <- function(target, extended = c("min", "full")) {
  trakt.people.media(type = "movies", target = target, extended = extended)
}

#' @rdname trakt.people.media
#' @export
trakt.people.shows <- function(target, extended = c("min", "full")) {
  trakt.people.media(type = "shows", target = target, extended = extended)
}

# Media that has people ----

#' Get the cast and crew of a show or movie
#'
#' Returns all cast and crew for a show/movie, depending on how much data is
#' available.
#' @inheritParams id_movie_show
#' @inheritParams extended_info
#' @inheritParams type_shows_movies
#' @return A `list`.
#' @export
#' @family people data
#' @seealso [trakt.people.media], for the other direction: People that have credits.
#' @examples
#' \dontrun{
#' breakingbad.people <- trakt.show.people("breaking-bad")
#' }
#'
trakt.media.people <- function(type = c("shows", "movies"), target,
                               extended = c("min", "full")) {

  type <- match.arg(type)
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "people", extended = extended)
  response <- trakt.api.call(url = url)

  # Flatten the data.frame
  response$cast <- cbind(
    response$cast[names(response$cast) != "person"],
    response$cast$person
  )
  response$cast <- cbind(
    response$cast[names(response$cast) != "ids"],
    response$cast$ids
  )

  response
}

#' @rdname trakt.media.people
#' @export
trakt.shows.people <- function(target, extended = c("min", "full")) {
  trakt.media.people(type = "shows", target = target, extended = extended)
}

#' @rdname trakt.media.people
#' @export
trakt.movies.people <- function(target, extended = c("min", "full")) {
  trakt.media.people(type = "movies", target = target, extended = extended)
}

