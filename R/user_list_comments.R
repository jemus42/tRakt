#' Get comments on a user-created list
#'
#' @inheritParams trakt_api_common_parameters
#' @inheritParams movies_comments
#' @inheritParams user_list_items
#'
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @family comment methods
#' @family list methods
#' @examples
#' \dontrun{
#' user_list_comments("donxy", "1248149")
#' }
user_list_comments <- function(user = getOption("trakt_username"),
                               list_id,
                               sort = c("newest", "oldest", "likes", "replies"),
                               extended = c("min", "full")) {

  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url(
    "users", user, "lists", list_id, "comments", sort, extended = extended
  )

  response <- trakt_get(url)
  unpack_comments(response)
}
