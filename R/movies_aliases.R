#' Get all movie / show aliases
#'
#' @name media_aliases
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @family movie data
#' @eval apiurl("movies", "aliases")
#' @examples
#' movies_aliases(190430)
#' shows_aliases(104439)
movies_aliases <- function(id) {
  url <- build_trakt_url("movies", id, "aliases")
  response <- trakt_get(url)

  as_tibble(response)
}

#' @rdname media_aliases
#' @family show data
#' @eval apiurl("shows", "aliases")
#' @export
shows_aliases <- function(id) {
  url <- build_trakt_url("shows", id, "aliases")
  response <- trakt_get(url)

  as_tibble(response)
}
