#' Get items (comments, lists) a user likes
#'
#' This requires authentication.
#'
#' @param type One of "comments", "lists".
#' @inherit trakt_api_common_parameters return
#' @export
#' @importFrom purrr discard pluck
#' @importFrom dplyr bind_cols
#' @examples
#' # Get liked lists
#' if (FALSE) {
#' user_likes("lists")
#' }
user_likes <- function(type = c("comments", "lists")) {

  type <- check_types(type, several.ok = FALSE, possible_types = c("comments", "lists"))

  url <- build_trakt_url("users", "likes", type)
  response <- trakt_get(url, auth = TRUE)

  if (type == "comments") {
    response %>%
      discard(is.list) %>%
      bind_cols(
        pluck(response, "comment") %>%
          unpack_comments()
      ) %>%
      fix_tibble_response()
  } else if (type == "lists") {
    response %>%
      discard(is.list) %>%
      bind_cols(
        pluck(response, "list") %>%
          unpack_lists()
      ) %>%
      fix_tibble_response()
  }
}
