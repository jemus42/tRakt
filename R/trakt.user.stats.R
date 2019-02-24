#' Get a user's stats
#'
#' `trakt.user.stats` retrieves a user's stats.
#' @inheritParams trakt_api_common_parameters
#' @return A list of [tibbles][tibble::tibble-package].
#' @export
#' @importFrom tibble enframe
#' @importFrom purrr modify_at
#' @family user data
#' @examples
#' \dontrun{
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
                                                   name = "rating", value = "n")

  # Exclude the last element (ratings) from tibbleization
  # to avoid duplication of "total" value across rows
  purrr::modify_at(response, -length(response), tibble::as_tibble)
}
