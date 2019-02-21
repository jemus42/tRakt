#' Get a user's watchlist
#'
#' `trakt.user.watchlist` pulls a user's watchlist.
#' Either all shows or movies currently watchlisted will be returned.
#' @param user Target user. Defaults to `getOption("trakt.username")`
#' @param type Either `shows` (default) or `movies`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `tibble` containing stats.
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
                                 type = c("movies", "shows"), extended = "min") {
  check_username(user)
  match.arg(type)
  if (length(type) > 1) type <- type[1]

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "watchlist", type, extended = extended)
  response <- trakt.api.call(url = url)

  if (identical(response, data.frame())) {
    return(tibble::tibble())
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
