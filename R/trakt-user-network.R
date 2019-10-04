#' Get a user's social connections
#'
#' Retrieve a user's followers, followings or friends (the two-way relationship).
#'
#' @details
#' The corresponding API methods
#' [are described in the API reference](https://trakt.docs.apiary.io/#reference/users/followers).
#'
#' The relevant endpoints for this function are, depending on `relationship`:
#' - `followers`: `users/:id/followers`
#' - `following`: `users/:id/following`
#' - `friends`: `users/:id/friends`
#' @aliases trakt.user.friends trakt.user.followers trakt.user.following
#' @param relationship `character(1) ["friends"]`: Type of user relationship. Either
#' `"friends"`, `"followers"`, or `"following"`.
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @note Since no OAuth2 methods are supported yet, the specified user must not be private.
#' @family user data
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
#' @importFrom tibble remove_rownames
#' @importFrom rlang has_name
#' @importFrom dplyr mutate_if
#' @examples
#' \dontrun{
#' trakt.user.network("friends", "jemus42")
#' trakt.user.network("following", "jemus42")
#' }
trakt.user.network <- function(relationship = c("friends", "followers", "following"),
                               user = getOption("trakt_username"),
                               extended = c("min", "full")) {
  check_username(user)
  extended <- match.arg(extended)
  relationship <- match.arg(relationship)

  if (length(user) > 1) {
    return(map_df(user, ~ trakt.user.network(relationship, user = .x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, relationship, extended = extended)
  response <- trakt_get(url = url)

  # Flatten the tbl
  response <- cbind(response[names(response) != "user"], response$user)
  response <- cbind(response[names(response) != "ids"], response$ids)

  # Drop avatars because no.
  if (has_name(response, "images")) {
    response$avatar <- response$images$avatar$full
    response <- response[names(response) != "images"]
  }

  # Consistency: "", NA, NULL, they should all be NA_character_
  response %>%
    mutate_if(is.character, fix_missing) %>%
    fix_tibble_response()
}
