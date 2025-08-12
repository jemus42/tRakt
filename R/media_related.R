# Internal worker ----
#' @keywords internal
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
#' @importFrom dplyr everything
#' @importFrom dplyr mutate
#' @noRd
media_related <- function(
	id,
	type = c("shows", "movies"),
	limit = 10L,
	extended = c("min", "full")
) {
	type <- match.arg(type)
	extended <- match.arg(extended)

	if (length(id) > 1) {
		return(map_df(id, \(x) media_related(x, type, extended)))
	}

	# Construct URL, make API call
	url <- build_trakt_url(type, id, "related", extended = extended, limit = limit)
	response <- trakt_get(url = url)

	# Flattening
	if (type == "shows") {
		response <- unpack_show(response)
	} else if (type == "movies") {
		response <- unpack_movie(response)
	}

	if (extended == "min" && type == "movies") {
		response <- response |>
			select(-"ids") |>
			bind_cols(fix_ids(response$ids))
	}

	response |>
		mutate(related_to = id) |>
		select("related_to", everything()) |>
		fix_tibble_response()
}

# Exported ----

#' Get similiar(ish) movies
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @family movie data
#' @eval apiurl("movies", "related")
#' @export
#' @examples
#' movies_related("the-avengers-2012", limit = 5)
movies_related <- function(id, limit = 10L, extended = c("min", "full")) {
	media_related(id, type = "movies", extended = extended, limit = limit)
}

#' Get similiar(ish) shows
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @family show data
#' @eval apiurl("shows", "related")
#' @export
#' @examples
#' shows_related("breaking-bad", limit = 5)
shows_related <- function(id, limit = 10L, extended = c("min", "full")) {
	media_related(id, type = "shows", extended = extended, limit = limit)
}
