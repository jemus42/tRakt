#' Get popular / trending lists
#'
#' @param type `character(1) ["personal"]`: The kind of lists to return, one of
#'   `"personal"` (user-created lists) or `"official"` (Trakt-curated lists).
#'   The trakt.tv API requires this path segment; a request without it returns
#'   an empty (HTTP 204) response.
#' @inheritParams trakt_api_common_parameters
#' @export
#' @family list methods
#' @family dynamic lists
#' @eval apiurl("lists", "popular")
#' @seealso [user_list_items()] For the actual content of a list.
#' @importFrom rlang is_empty
#' @importFrom dplyr bind_cols select_if pull
#' @importFrom purrr pluck
#' @inherit trakt_api_common_parameters return
#' @examplesIf trakt_api_available()
#' lists_popular()
#' lists_trending()
lists_popular <- function(limit = 10, type = c("personal", "official")) {
	type <- match.arg(type)
	url <- build_trakt_url("lists/popular", type, limit = limit)
	response <- trakt_get(url)

	if (is_empty(response)) {
		return(tibble())
	}

	response |>
		pull("list") |>
		select_if(\(x) !is.data.frame(x)) |>
		bind_cols(
			pluck(response, "list", "ids") |> fix_ids(),
			pluck(response, "list", "user") |> unpack_user()
		) |>
		fix_tibble_response()
}

#' @rdname lists_popular
#' @export
#' @family list methods
#' @family dynamic lists
#' @eval apiurl("lists", "trending")
#' @importFrom rlang is_empty
#' @importFrom dplyr bind_cols select_if pull
#' @importFrom purrr pluck
lists_trending <- function(limit = 10, type = c("personal", "official")) {
	type <- match.arg(type)
	url <- build_trakt_url("lists/trending", type, limit = limit)
	response <- trakt_get(url)

	if (is_empty(response)) {
		return(tibble())
	}

	response |>
		pull("list") |>
		select_if(\(x) !is.data.frame(x)) |>
		bind_cols(
			pluck(response, "list", "ids") |> fix_ids(),
			pluck(response, "list", "user") |> unpack_user()
		) |>
		fix_tibble_response()
}
