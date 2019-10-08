#' Get a user's comments
#'
#' @inheritParams trakt_api_common_parameters
#' @param comment_type `character(1) ["all"]`: The type of comment, one of "all",
#'   "reviews" or "shouts".
#' @param type `character(1) ["all"]`: The type of media to filter by, one of
#'   "all", "movies", "shows", "seasons", "episodes" or "lists".
#' @param include_replies `logical(1) [FALSE]`: Whether to include replies.
#'
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @importFrom dplyr select filter pull bind_cols
#' @importFrom purrr map_df
#' @importFrom rlang is_empty
#' @examples
#' \dontrun{
#' user_comments("jemus42")
#' }
user_comments <- function(user = getOption("trakt_username"),
                          comment_type = c("all", "reviews", "shouts"),
                          type = c("all", "movies", "shows", "seasons",
                                   "episodes", "lists"),
                          include_replies = FALSE) {

  comment_type <- match.arg(comment_type)
  type <- match.arg(type)

  url <- build_trakt_url(
    "users", user, "comments", comment_type, type, include_replies = include_replies
  )
  response <- trakt_get(url)

  if (is_empty(response)) {
    return(tibble())
  }

  # What types are present in the list
  list_types <- unique(response$type)

  # Get the list "base" without media items
  # in this case only a type column
  list_base <- response %>% select("type")

  # Row-bind the list base to the unpackaed media items
  map_df(list_types, ~ {
    bind_cols(
      list_base %>%
        filter(type == .x),
      response %>%
        filter(type == .x) %>%
        pull("comment") %>%
        unpack_comments(),
      flatten_media_object(response, .x)
    )
  }) %>%
    fix_tibble_response()
}
