#' Get a user's watchlist
#'
#' `trakt.user.watchlist` pulls a user's watchlist.
#' Either all shows or movies currently watchlisted will be returned.
#' @param user Target user. Defaults to `getOption("trakt.username")`
#' @param type Either `shows` (default) or `movies`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `data.frame` containing stats.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/users/ratings/get-watchlist}{the trakt API docs for further info}
#' @family user data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' mystats <- trakt.user.watchlist() # Defaults to your username if set
#' seanstats <- trakt.user.watchlist(user = "sean")
#' }
trakt.user.watchlist <- function(user = getOption("trakt.username"), type = "shows", extended = "min") {
  if (is.null(user) && is.null(getOption("trakt.username"))) {
    stop("No username is set.")
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "watchlist", type, extended = extended)
  response <- trakt.api.call(url = url)

  if (type == "shows") {
    response <- cbind(response[names(response) != "show"], response$show)
  } else if (type == "movies") {
    response <- cbind(response[names(response) != "movie"], response$movie)
  }
  response <- cbind(response[names(response) != "ids"], response$ids)
  response <- convert_datetime(response)
  return(response)
}
