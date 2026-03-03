#' Get a single person's details
#'
#' Get a single person's details, like their various IDs. If `extended` is
#' `"full"`, there will also be biographical data if available, e.g. their
#' birthday.
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @importFrom purrr modify_if
#' @family people data
#' @family summary methods
#' @eval apiurl("people", "summary")
#' @examples
#' # A single person's extended information
#' people_summary("bryan-cranston", "full")
#'
#' # Multiple people
#' people_summary(c("kit-harington", "emilia-clarke"))
people_summary <- function(id, extended = "min") {
	if (length(id) > 1) {
		return(map_rbind(id, \(x) people_summary(x, extended)))
	}

	extended <- validate_extended(extended)

	# Construct URL, make API call
	url <- build_trakt_url("people", id, extended = extended$query_value)
	response <- trakt_get(url = url)

	ids <- as_tibble(fix_ids(response$ids))

	# Flatten social_ids into prefixed columns
	social <- NULL
	if (!is.null(response$social_ids)) {
		social <- modify_if(response$social_ids, is.null, \(x) NA_character_)
		names(social) <- paste0("social_", names(social))
		social <- as_tibble(social)
	}

	response <- response |>
		modify_if(is.null, \(x) NA_character_) |>
		discard(is.list) |>
		as_tibble() |>
		bind_cols(ids)

	if (!is.null(social)) {
		response <- bind_cols(response, social)
	}

	fix_tibble_response(response, keep_images = extended$keep_images)
}
