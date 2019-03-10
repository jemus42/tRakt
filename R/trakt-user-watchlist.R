#' Get a user's watchlist
#'
#' Retrieve a user's watchlisted shows or movies.
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#' @family user data
#' @examples
#' \dontrun{
#' # Defaults to movie watchlist and minimal info
#' trakt.user.watchlist(user = "sean")
#' }
trakt.user.watchlist <- function(user = getOption("trakt_username"),
                                 type = c("movies", "shows"),
                                 extended = c("min", "full")) {
  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(user) > 1) {
    names(user) <- user
    return(map_df(user, ~ trakt.user.watchlist(user = .x, type, extended), .id = "user"))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "watchlist", type, extended = extended)
  response <- trakt_get(url = url)

  if (identical(response, tibble())) {
    return(response)
  }

  if (type == "shows") {
    response <- cbind(response[names(response) != "show"], unpack_show(response$show))
  } else if (type == "movies") {
    response <- unpack_movie(response)
  }

  fix_tibble_response(response)
}
