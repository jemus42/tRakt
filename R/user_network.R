#' Get a user's social connections
#'
#' Get followers, followings or friends (the two-way relationship).
#' @name user_network
#' @details
#' The corresponding API methods are described in
#' [the API reference](https://trakt.docs.apiary.io/#reference/users/followers).
#'
#' The relevant endpoints for this function are:
#' - `user_followers`: `users/:id/followers`
#' - `user_following`: `users/:id/following`
#' - `user_friends`: `users/:id/friends`
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @note If the specified user is private, you need to be able to make an [authenticated
#' request][trakt_credentials] and be friends with the user.
#' @family user data
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
#' @importFrom tibble remove_rownames
#' @importFrom rlang has_name
#' @importFrom dplyr mutate_if
NULL

#' User network worker function
#' @keywords internal
#' @noRd
user_network <- function(relationship = c("friends", "followers", "following"),
                         user = getOption("trakt_username"),
                         extended = c("min", "full")) {
  check_username(user)
  extended <- match.arg(extended)
  relationship <- match.arg(relationship)

  if (length(user) > 1) {
    return(map_df(user, ~ user_network(relationship, user = .x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, relationship, extended = extended)
  response <- trakt_get(url = url)

  # Flatten the tbl
  response <- cbind(response[names(response) != "user"], response$user)
  response <- cbind(response[names(response) != "ids"], response$ids)

  #  Extract avatars
  if (has_name(response, "images")) {
    response$avatar <- response$images$avatar$full
    response <- response[names(response) != "images"]
  }

  # Consistency: "", NA, NULL, they should all be NA_character_
  response %>%
    mutate_if(is.character, fix_missing) %>%
    fix_tibble_response()
}

#' Get a user's followers
#' @rdname user_network
#' @export
#' @examples
#' \dontrun{
#' user_followers(user = "sean")
#' }
user_followers <- function(user = getOption("trakt_user"), extended = "min") {
  user_network(relationship = "followers", user = user, extended = extended)
}

#' Get a user's followings
#' @rdname user_network
#' @export
#' @examples
#' \dontrun{
#' user_following(user = "sean")
#' }
user_following <- function(user = getOption("trakt_user"), extended = "min") {
  user_network(relationship = "following", user = user, extended = extended)
}

#' Get a user's friends
#' @rdname user_network
#' @export
#' @examples
#' \dontrun{
#' user_friends(user = "sean")
#' }
user_friends <- function(user = getOption("trakt_user"), extended = "min") {
  user_network(relationship = "friends", user = user, extended = extended)
}
