#' Returns stats about the movies, shows, and episodes a user has watched,
#' collected, and rated.
#'
#' Data about a user's interactions with movies, shows, seasons, episodes,
#' as well as their social network (friends, followings, followers) and a
#' frequency table of the user's media ratings so far.
#' @details
#' This function wraps the API method
#' [`/users/:id/stats`](https://trakt.docs.apiary.io/#reference/users/stats/get-stats).
#' @inheritParams trakt_api_common_parameters
#' @return A `list` of [tibbles][tibble::tibble-package] containing the following elements:
#' - "movies"
#' - "shows"
#' - "seasons"
#' - "episodes"
#' - "network"
#' - "ratings"
#' @export
#' @importFrom purrr map
#' @family user data
#' @examples
#' \dontrun{
#' user_stats(user = "sean")
#' }
user_stats <- function(user = getOption("trakt_username")) {
  check_username(user)

  if (length(user) > 1) {
    names(user) <- user
    return(map(user, ~ user_stats(user = .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "stats")
  response <- trakt_get(url = url)

  if (identical(response, tibble())) {
    return(response)
  }

  # Flattening/list-columnifying the distribution a little
  response$ratings <- fix_ratings_distribution(response$ratings)

  map(response, as_tibble)
}
