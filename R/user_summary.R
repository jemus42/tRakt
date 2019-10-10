#' Get a user's profile
#'
#' @details
#' The corresponding API methods is
#' [`users/:id`](https://trakt.docs.apiary.io/#reference/users/profile/get-user-profile).
#'
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @note If the specified user is private, you need to be able to make an [authenticated
#' request][trakt_credentials] and be friends with the user.
#' @family user data
#' @examples
#' \dontrun{
#' user_profile("sean")
#' }
user_profile <- function(user = getOption("trakt_username"),
                         extended = c("min", "full")) {
  check_username(user)
  extended <- match.arg(extended)

  if (length(user) > 1) {
    return(map_df(user, ~ user_profile(user = .x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, extended = extended)
  response <- trakt_get(url = url)

  response %>%
    as_tibble() %>%
    unpack_user()
}
