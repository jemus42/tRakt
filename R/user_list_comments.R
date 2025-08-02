#' Get comments on a user-created list
#'
#' @inheritParams trakt_api_common_parameters
#' @inheritParams movies_comments
#' @inheritParams user_list_items
#' @inherit trakt_api_common_parameters return
#' @export
#' @family comment methods
#' @family list methods
#' @eval apiurl("users", "list comments")
#' @examples
#' \dontrun{
#' user_list_comments("donxy", "1248149")
#' }
user_list_comments <- function(
	user = "me",
	list_id,
	sort = c("newest", "oldest", "likes", "replies"),
	extended = c("min", "full")
) {
	sort <- match.arg(sort)
	extended <- match.arg(extended)

	url <- build_trakt_url(
		"users",
		user,
		"lists",
		list_id,
		"comments",
		sort,
		extended = extended
	)

	response <- trakt_get(url)
	unpack_comments(response)
}
