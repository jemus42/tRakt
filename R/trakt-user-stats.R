#' Get a user's stats
#'
#' Data about a user's interactions with movies, shows, seasons, episodes,
#' as well as their social network (friends, followings, followers) and a
#' frequency table of the user's media ratings so far.
#' @inheritParams trakt_api_common_parameters
#' @return A `list` of [tibbles][tibble::tibble-package].
#' @export
#' @importFrom purrr map
#' @family user data
#' @examples
#' \dontrun{
#' trakt.user.stats(user = "sean")
#' }
trakt.user.stats <- function(user = getOption("trakt.username")) {
  check_username(user)

  if (length(user) > 1) {
    names(user) <- user
    return(map(user, ~ trakt.user.stats(user = .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "stats")
  response <- trakt_get(url = url)

  # Flattening/list-columnifying the distribution a little
  response$ratings <- fix_ratings_distribution(response$ratings)

  map(response, as_tibble)
}
