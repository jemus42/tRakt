#' Get a user's ratings
#'
#' `trakt.user.ratings` retrieves a user's ratings
#' @inheritParams trakt_api_common_parameters
#' @param rating A rating to filter by. Can be `1` through `10`, default is `NULL`
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/ratings/get-ratings}{the trakt API docs for further info}
#' @family user data
#' @examples
#' \dontrun{
#' trakt.user.ratings(user = "jemus42")
#' trakt.user.ratings(user = "jemus42", type = "movies")
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
    response$show <- cbind(response$show[names(response$show) != "ids"],
                           fix_ids(response$show$ids))
    response <- cbind(response[names(response) != "show"], response$show)
  } else if (type == "movies") {
    response$movie <- cbind(response$movie[names(response$movie) != "ids"],
                            fix_ids(response$movie$ids))
    response <- cbind(response[names(response) != "movie"], response$movie)
  } else if (type == "episodes") {
    # Prepend ids to avoid duplicates
    names(response$episode$ids) <- paste0("episode.", names(response$episode$ids))
    names(response$show)[-3] <- paste0("show.", names(response$show)[-3])
    names(response$show$ids) <- paste0("show.", names(response$show$ids))
    # Move stuff around to flatten the DF
    response$episode <- cbind(response$episode[names(response$episode) != "ids"],
                              fix_ids(response$episode$ids))
    response$show <- cbind(response$show[names(response$show) != "ids"],
                           fix_ids(response$show$ids))
    response <- cbind(response[names(response) != "episode"], response$episode)
    response <- cbind(response[names(response) != "show"], response$show)
    names(response) <- sub("number", "episode", names(response))
  }
  tibble::as_tibble(response)
}
