#' Get a user's profile
#'
#' @details
#' The corresponding API methods is
#' [`users/:id`](https://trakt.docs.apiary.io/#reference/users/profile/get-user-profile).
#'
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @note If the specified user is private, you need to be able to make an [authenticated
#' request][trakt_credentials] and be friends with the user.
#' @family user data
#' @examples
#' \dontrun{
#' user_summary("sean")
#' }
user_summary <- function(user = getOption("trakt_username"),
                         extended = c("min", "full")) {
  check_username(user)
  extended <- match.arg(extended)

  if (length(user) > 1) {
    return(map_df(user, ~ user_summary(user = .x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, extended = extended)
  response <- trakt_get(url = url)
  response <- as_tibble(response)

  if (identical(response, tibble())) {
    return(response)
  }

  # Flatten the tbl
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
