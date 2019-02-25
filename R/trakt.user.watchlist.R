#' Get a user's watchlist
#'
#' `trakt.user.watchlist` pulls a user's watchlist.
#' Either all shows or movies currently watchlisted will be returned.
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/users/ratings/get-watchlist}{the trakt API docs for further info}
#' @family user data
#' @examples
#' \dontrun{
#' library(tRakt)
#' movie_watchlist <- trakt.user.watchlist(type = "movies") # Defaults to your username if set
#' sean_movies <- trakt.user.watchlist(user = "sean") # Defaults to movie watchlist
#' }
trakt.user.watchlist <- function(user = getOption("trakt.username"),
                                 type = c("movies", "shows"), extended = c("min", "full")) {
  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "watchlist", type, extended = extended)
  response <- trakt.api.call(url = url)

  if (identical(response, tibble::tibble())) {
    return(response)
  }

  if (type == "shows") {
    response <- cbind(response[names(response) != "show"], response$show)
  } else if (type == "movies") {
    response <- cbind(response[names(response) != "movie"], response$movie)
  }
  response <- cbind(response[names(response) != "ids"], response$ids)
  response <- convert_datetime(response)
  tibble::as_tibble(response)
}
