#' Get items (comments, lists) a user likes
#'
#' @param type `character(1) ["comments"]`: One of "comments", "lists".
#' @inherit trakt_api_common_parameters return
#' @export
#' @family user data
#' @eval apiurl("users", "likes")
#' @importFrom purrr discard pluck
#' @importFrom dplyr bind_cols
#' @examples
#' # Get liked lists (only if there's a client secret set)
#' # See ?trakt_credentials
#' if (trakt_credentials()[["client_secret"]]) {
#'   user_likes("lists")
#' }
user_likes <- function(type = c("comments", "lists")) {
  type <- check_types(type, several.ok = FALSE, possible_types = c("comments", "lists"))

  url <- build_trakt_url("users", "likes", type)
  response <- trakt_get(url)

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
