#' Get the weekend box office
#'
#' Returns the top 10 grossing movies in the U.S. box office last weekend.
#' Updated every Monday morning.
#'
#' @details
#' This function wraps the endpoint
#' [movies/boxoffice](https://trakt.docs.apiary.io/#reference/movies/box-office/get-the-weekend-box-office).
#'
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @family movie data
#' @importFrom tibble as_tibble
#' @examples
#' movies_boxoffice()
movies_boxoffice <- function(extended = c("min", "full")) {
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url("movies/boxoffice", extended = extended)
  response <- trakt_get(url = url)

  response %>%
    unpack_movie() %>%
    fix_tibble_response()
}
