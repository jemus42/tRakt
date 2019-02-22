#' Get a user's stats
#'
#' `trakt.user.stats` retrieves a user's stats.
#' @param user Target user. Defaults to `getOption("trakt.username")`
#' @return A `list` of [tibbles][tibble::tibble-package].
#' @export
#' @importFrom tibble enframe
#' @importFrom purrr modify_at
#' @note See \href{http://docs.trakt.apiary.io/reference/users/stats/get-stats}{the trakt API docs for further info}
#' @family user data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' mystats <- trakt.user.stats() # Defaults to your username if set
#' seanstats <- trakt.user.stats(user = "sean")
#' }
trakt.user.stats <- function(user = getOption("trakt.username")) {
  check_username(user)

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "stats")
  response <- trakt.api.call(url = url)

  # Flattening the distribution a little
  response$ratings$distribution <- tibble::enframe(unlist(response$ratings$distribution),
    name = "rating", value = "n"
  )

  # Exclude the last element (ratings) from tibbleization
  # to avoid duplication of "total" value across rows
  purrr::modify_at(response, -length(response), tibble::as_tibble)
}
