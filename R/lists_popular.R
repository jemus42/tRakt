#' Get popular / trending lists
#'
#' @inheritParams trakt_api_common_parameters
#'
#' @return A [tibble()][tibble::tibble-package] of length `limit`.
#' @export
#' @family list methods
#' @seealso [user_list_items] For the actual content of a list.
#' @importFrom rlang is_empty
#' @importFrom dplyr bind_cols select_if pull
#' @importFrom purrr pluck
#' @examples
#' \dontrun{
#' lists_popular()
#' lists_trending()
#' }
lists_popular <- function(limit = 10) {

  url <- build_trakt_url("lists/popular", limit = limit)
  response <- trakt_get(url)

  if (is_empty(response)) {
    return(tibble())
  }

  response %>%
    pull("list") %>%
    select_if(~!is.data.frame(.x)) %>%
    bind_cols(
      pluck(response, "list", "ids") %>% fix_ids(),
      pluck(response, "list", "user") %>% unpack_user()
    ) %>%
    fix_tibble_response()
}

#' @rdname lists_popular
#' @export
#' @importFrom rlang is_empty
#' @importFrom dplyr bind_cols select_if pull
#' @importFrom purrr pluck
lists_trending <- function(limit = 10) {

  url <- build_trakt_url("lists/trending", limit = limit)
  response <- trakt_get(url)

  if (is_empty(response)) {
    return(tibble())
  }

  response %>%
    pull("list") %>%
    select_if(~!is.data.frame(.x)) %>%
    bind_cols(
      pluck(response, "list", "ids") %>% fix_ids(),
      pluck(response, "list", "user") %>% unpack_user()
    ) %>%
    fix_tibble_response()
}



