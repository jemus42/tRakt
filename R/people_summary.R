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
people_summary <- function(id, extended = c("min", "full")) {
	extended <- match.arg(extended)

	if (length(id) > 1) {
		return(map(id, \(x) people_summary(x, extended)) |> list_rbind())
	}

	# Construct URL, make API call
	url <- build_trakt_url("people", id, extended = extended)
	response <- trakt_get(url = url)

	# Substitute NULLs with explicit NAs and flatten IDs
	response$ids <- as_tibble(fix_ids(response$ids))
	response <- modify_if(response, is.null, \(x) NA_character_)
	response <- fix_datetime(response)
	response[names(response) != "ids"] |>
		as_tibble() |>
		bind_cols(response$ids)
}
