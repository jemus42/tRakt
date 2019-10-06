#' Get a user's lists
#'
#' Retrieve all lists a user has created together with information about the user.
#' Use `extended = "full"` to retrieve all user profile data, similiar to [user_profile].
#' The returned variables `trakt` (list ID) or `slug` (list slug) can be used to
#' retrieve the list's items via [user_list_items].
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @importFrom dplyr select pull bind_cols
#' @importFrom rlang is_empty
#' @note In the embedded user data, `name` is renamed to `user_name` due
#'   to duplication with e.g. list names,
#'   and `slug` is renamed to `user_slug` for the same reason.
#' @examples
#' \dontrun{
#' user_lists("jemus42")
#' }
user_lists <- function(user = getOption("trakt_username"), extended = c("min", "full")) {
  check_username(user)
  extended <- match.arg(extended)

  url <- build_trakt_url("users", user, "lists", extended = extended)
  response <- trakt_get(url)

  if (is_empty(response)) {
    return(tibble())
  }

  response %>%
    select(-user, -ids) %>%
    bind_cols(
      response %>%
        pull(ids),
      response %>%
        pull(user) %>%
        unpack_user()
    ) %>%
    fix_tibble_response()

}


