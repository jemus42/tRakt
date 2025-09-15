#' Get a season of a show
#'
#' Similar to [seasons_summary], but this function returns only metadata for a season.
#' @inheritParams trakt_api_common_parameters
#' @param seasons `integer(1) [1L]`: The season(s) to get. Use `0` for specials.
#' @inheritParams seasons_summary
#' @inherit trakt_api_common_parameters return
#' @export
#' @importFrom lubridate year
#' @importFrom rlang is_integerish
#' @importFrom purrr is_integer
#' @note If you want to quickly gather episode data of all available seasons,
#' see [seasons_summary] and use the `episodes = TRUE` parameter.
#' @family season data
#' @eval apiurl("seasons", "season")
#' @examples
#' \dontrun{
#' seasons_season("breaking-bad", 1)
#'
#' # Including all episode data:
#' seasons_season("breaking-bad", 1, extended = "full")
#' }
seasons_season <- function(id, seasons = 1L, extended = c("min", "full")) {
	extended <- match.arg(extended)

	# Vectorize
	if (length(seasons) > 1) {
		return(map(seasons, \(x) seasons_season(id, x, extended)) |> list_rbind())
	}

	# Basic sanity check
	# Do this after vectorization due to scalar ifs
	if (!rlang::is_integerish(seasons)) {
		stop("'seasons' cannot be coerced to integer: '", seasons, "'")
	}

	# Construct URL, make API call
	url <- build_trakt_url("shows", id, "seasons", seasons, "info", extended = extended)
	response <- trakt_get(url = url)

	if (identical(response, tibble())) {
		return(tibble())
	}

	if (extended == "min") {
		tibble(number = response$number, as_tibble(fix_ids(response$ids)))
	} else {
		discard(response, is.list) |>
			map(\(x) if (is.null(x)) NA else x) |>
			as_tibble() |>
			bind_cols(fix_ids(response$ids))
	}
}
