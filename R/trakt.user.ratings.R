#' Get a user's ratings
#'
#' `trakt.user.ratings` pulls a user's ratings
#' @param user Target user. Defaults to `getOption("trakt.username")`
#' @param type Either `shows` (default), `episodes` or `movies`
#' @param rating A rating to filter by. Can be `1` through `10`, default is `NULL`
#' @inherit return_tibble return
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/ratings/get-ratings}{the trakt API docs for further info}
#' @family user data
#' @examples
#' \dontrun{
#' ratedshows <- trakt.user.ratings()
#' ratedmovies <- trakt.user.ratings(type = "movies")
#' }
trakt.user.ratings <- function(user = getOption("trakt.username"),
                               type = c("shows", "episodes", "movies"), rating = NULL) {
  check_username(user)
  type <- match.arg(type)
  
  if (!is.null(rating)) {
    if (!(as.numeric(rating) %in% 1:10)) {
      stop("rating must be between 1 and 10")
    }
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "ratings", type, rating)
  response <- trakt.api.call(url = url)

  # Flattening
  if (type == "shows") {
    response$show <- cbind(response$show[names(response$show) != "ids"], response$show$ids)
    response <- cbind(response[names(response) != "show"], response$show)
  } else if (type == "movies") {
    response$movie <- cbind(response$movie[names(response$movie) != "ids"], response$movie$ids)
    response <- cbind(response[names(response) != "movie"], response$movie)
  } else if (type == "episodes") {
    # Prepend ids to avoid duplicates
    names(response$episode$ids) <- paste0("episode.", names(response$episode$ids))
    names(response$show)[-3] <- paste0("show.", names(response$show)[-3])
    names(response$show$ids) <- paste0("show.", names(response$show$ids))
    # Move stuff around to flatten the DF
    response$episode <- cbind(response$episode[names(response$episode) != "ids"], response$episode$ids)
    response$show <- cbind(response$show[names(response$show) != "ids"], response$show$ids)
    response <- cbind(response[names(response) != "episode"], response$episode)
    response <- cbind(response[names(response) != "show"], response$show)
    names(response) <- sub("number", "episode", names(response))
  }
  tibble::as_tibble(response)
}
