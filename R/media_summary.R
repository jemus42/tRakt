# Internal worker ----

#' @keywords internal
#' @noRd
#' @importFrom purrr modify_if
#' @importFrom rlang has_name
#' @importFrom lubridate as_datetime
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
media_summary <- function(type = c("movies", "shows"), id, extended = "min") {
	type <- match.arg(type)

	if (length(id) > 1) {
		return(map_rbind(id, \(x) media_summary(type, id = x, extended)))
	}

	extended <- validate_extended(extended)

	# Construct URL, make API call
	url <- build_trakt_url(type, id, extended = extended$query_value)
	response <- trakt_get(url = url)

	if (is_empty(response)) {
		return(tibble())
	}

	flatten_single_media_object(response, type, keep_images = extended$keep_images)
}

# Exported ----

#' Get a single movie
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "summary")
#' @family movie data
#' @family summary methods
#' @examples
#' # Minimal info by default
#' movies_summary("inception-2010")
#' \dontrun{
#' # Full information,  multiple movies
#' movies_summary(c("inception-2010", "the-dark-knight-2008"), extended = "full")
#' }
movies_summary <- function(id, extended = "min") {
	media_summary(type = "movies", id = id, extended = extended)
}

#' Get a single show
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @family show data
#' @family summary methods
#' @eval apiurl("shows", "summary")
#' @examples
#' # Minimal info by default
#' shows_summary("breaking-bad")
#' \dontrun{
#' # More information
#' shows_summary("breaking-bad", extended = "full")
#' }
shows_summary <- function(id, extended = "min") {
	media_summary(type = "shows", id = id, extended = extended)
}
