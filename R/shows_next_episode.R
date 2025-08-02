#' Get a shows next or latest episode
#'
#' @inheritParams trakt_api_common_parameters
#'
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("shows", "next episode")
#' @family show data
#' @family episode data
#' @importFrom dplyr bind_cols
#' @importFrom purrr discard modify_if modify_at pluck
#' @importFrom rlang is_empty
#' @examples
#' shows_next_episode("one-piece")
#' shows_last_episode("one-piece", extended = "full")
shows_next_episode <- function(id, extended = c("min", "full")) {
	extended <- match.arg(extended)

	url <- build_trakt_url("shows", id, "next_episode", extended = extended)
	response <- trakt_get(url)

	if (is_empty(response)) {
		return(tibble::tibble())
	}

	response |>
		discard(is.list) |>
		modify_if(is.null, ~NA_character_) |>
		modify_at(~ grepl("(^available_translations$)|(^genres$)", .x), list) |>
		as_tibble() |>
		bind_cols(
			pluck(response, "ids") |> fix_ids()
		)
}

#' @rdname shows_next_episode
#' @eval apiurl("shows", "last episode")
#' @family show data
#' @family episode data
#' @export
shows_last_episode <- function(id, extended = c("min", "full")) {
	extended <- match.arg(extended)

	url <- build_trakt_url("shows", id, "last_episode", extended = extended)
	response <- trakt_get(url)

	response |>
		discard(is.list) |>
		modify_if(is.null, ~NA_character_) |>
		modify_at(~ grepl("(^available_translations$)|(^genres$)", .x), list) |>
		as_tibble() |>
		bind_cols(
			pluck(response, "ids") |> fix_ids()
		)
}
