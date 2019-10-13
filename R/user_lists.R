#' Get a user's lists
#'
#' Retrieve all lists a user has created together with information about the user.
#' Use `extended = "full"` to retrieve all user profile data, similiar to [user_profile].
#' The returned variables `trakt` (list ID) or `slug` (list slug) can be used to
#' retrieve the list's items via [user_list_items].
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @family list methods
#' @eval apiurl("users", "lists")
#' @seealso [user_lists] for all lists a user has.
#' @seealso [user_list_items] For the actual content of a list.
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
    select(-"user", -"ids") %>%
    bind_cols(
      response %>%
        pull(.data[["ids"]]),
      response %>%
        pull(.data[["user"]]) %>%
        unpack_user()
    ) %>%
    fix_tibble_response()
}


#' Get a single list
#'
#' Retrieve a single list a user has created together with information about the user.
#' Use `extended = "full"` to retrieve all user profile data, similiar to [user_profile].
#' The returned variables `trakt` (list ID) or `slug` (list slug) can be used to
#' retrieve the list's items via [user_list_items].
#' @inheritParams trakt_api_common_parameters
#' @inheritParams user_list_items
#' @inherit trakt_api_common_parameters return
#' @export
#' @family list methods
#' @seealso [user_list] for only a single list.
#' @seealso [user_list_items] For the actual content of a list.
#' @importFrom dplyr select pull bind_cols
#' @importFrom rlang is_empty
#' @importFrom purrr discard
#' @note In the embedded user data, `name` is renamed to `user_name` due
#'   to duplication with e.g. list names,
#'   and `slug` is renamed to `user_slug` for the same reason.
#' @examples
#' \dontrun{
#' user_list("jemus42", list_id = 2121308)
#' }
user_list <- function(user = getOption("trakt_username"), list_id,
                      extended = c("min", "full")) {
  check_username(user)
  extended <- match.arg(extended)

  url <- build_trakt_url("users", user, "lists", list_id, extended = extended)
  response <- trakt_get(url)

  if (is_empty(response)) {
    return(tibble())
  }

  response %>%
    discard(is.list) %>%
    as_tibble() %>%
    bind_cols(
      response$ids %>%
        as_tibble(),
      response$user %>%
        as_tibble() %>%
        unpack_user()
    ) %>%
    fix_tibble_response()
}
