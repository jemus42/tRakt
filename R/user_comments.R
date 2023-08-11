#' Get a user's comments
#'
#' @inheritParams trakt_api_common_parameters
#' @param comment_type `character(1) ["all"]`: The type of comment, one of "all",
#'   "reviews" or "shouts".
#' @param type `character(1) ["all"]`: The type of media to filter by, one of
#'   "all", "movies", "shows", "seasons", "episodes" or "lists".
#' @param include_replies `logical(1) [FALSE]`: Whether to include replies.
#'
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("users", "comments")
#' @family user data
#' @family comment methods
#' @importFrom dplyr select filter pull bind_cols
#' @importFrom purrr map_df
#' @importFrom rlang is_empty
#' @examples
#' \dontrun{
#' user_comments("jemus42")
#' }
user_comments <- function(user = "me",
                          comment_type = c("all", "reviews", "shouts"),
                          type = c(
                            "all", "movies", "shows", "seasons",
                            "episodes", "lists"
                          ),
                          include_replies = FALSE) {
  comment_type <- match.arg(comment_type)
  type <- match.arg(type)

  url <- build_trakt_url(
    "users", user, "comments", comment_type, type,
    include_replies = include_replies
  )
  response <- trakt_get(url)

  unpack_comments_multitype(response)
}
