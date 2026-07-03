# Worker function ----
#' @keywords internal
#' @importFrom rlang has_name
#' @importFrom dplyr select bind_rows
#' @noRd
trakt_auto_lists <- function(
	list_type = c(
		"popular",
		"trending",
		"anticipated",
		"played",
		"watched",
		"collected",
		"updates"
	),
	type = c("shows", "movies"),
	limit = 10L,
	extended = "min",
	period = NULL,
	start_date = NULL,
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL,
	networks = NULL,
	status = NULL,
	# Captures the user's calling frame (through the public wrapper) so the
	# soft-deprecation of the legacy flat filter arguments targets user code.
	user_env = rlang::caller_env(2)
) {
	# Check arguments
	list_type <- match.arg(list_type)
	type <- match.arg(type)

	extended <- validate_extended(extended)
	limit <- as.integer(limit)

	# Reconcile the `filters` object with any legacy individual filter arguments.
	filters <- resolve_filters(
		filters,
		flat = list(
			query = query,
			years = years,
			genres = genres,
			languages = languages,
			countries = countries,
			runtimes = runtimes,
			ratings = ratings,
			certifications = certifications,
			networks = networks,
			status = status
		),
		context = type,
		user_env = user_env
	)

	# Check limit
	if (limit < 1) {
		cli::cli_abort("{.arg limit} must be greater than zero, not {.val {limit}}.")
	}

	# Construct URL, make API call. Filter query parameters are spliced in from
	# the validated `filters` object.
	url <- do.call(
		build_trakt_url,
		c(
			list(
				type,
				list_type,
				start_date,
				period,
				limit = limit,
				extended = extended$query_value
			),
			unclass(filters)
		)
	)
	response <- trakt_get(url)
	response <- as_tibble(response)

	# For this case we *only* get show objects, so we handle that first
	if (type == "shows" && list_type == "popular") {
		response <- unpack_show(response, keep_images = extended$keep_images)
	}

	# Unnest show or movie object present only in some methods
	if (has_name(response, "show")) {
		response <- bind_cols(
			response |> select(-"show"),
			unpack_show(response$show, keep_images = extended$keep_images)
		)
	}

	if (has_name(response, "movie")) {
		response <- bind_cols(
			response |> select(-"movie"),
			response$movie |> select(-"ids"),
			response$movie$ids
		)
	}

	# Unpack ids – required for extended = "min"
	# This is done last because at this point we can be
	# reasonably certain there's no other problematic list/df columns
	if (has_name(response, "ids")) {
		response <- bind_cols(
			response |> select(-"ids"),
			response$ids
		)
	}

	fix_tibble_response(response, keep_images = extended$keep_images)
}

# NOTE: The public wrappers below still expose the individual filter arguments
# (`query`, `years`, `genres`, ...) for backwards compatibility. These are
# soft-deprecated in favour of the `filters` argument (see `filters_shows()` et
# al.). Once they are removed, each wrapper collapses to just `limit`,
# `extended`, `filters` (and `period` for the watched/collected/played family),
# so this whole section can be simplified substantially at that point.

# Popular ----

#' Popular media
#'
#' These functions return the popular movies/shows on trakt.tv.
#' @name popular_media
#' @inheritParams trakt_api_common_parameters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "popular")
#' @family movie data
#' @family dynamic lists
#' @examplesIf trakt_api_available()
#' # Get the most popular German-language movies between 2000 and 2010
#' movies_popular(filters = filters_movies(languages = "de", years = c(2000, 2010)))
movies_popular <- function(
	limit = 10,
	extended = "min",
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL
) {
	trakt_auto_lists(
		list_type = "popular",
		type = "movies",
		limit = limit,
		extended = extended,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications
	)
}

#' @rdname popular_media
#' @eval apiurl("shows", "popular")
#' @family shows data
#' @family dynamic lists
#' @export
shows_popular <- function(
	limit = 10,
	extended = "min",
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL,
	networks = NULL,
	status = NULL
) {
	trakt_auto_lists(
		list_type = "popular",
		type = "shows",
		limit = limit,
		extended = extended,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications,
		networks = networks,
		status = status
	)
}

# Trending ----

#' Trending media
#'
#' These functions return the trending movies/shows on trakt.tv.
#' @name trending_media
#' @inheritParams trakt_api_common_parameters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "trending")
#' @family movie data
#' @family dynamic lists
movies_trending <- function(
	limit = 10,
	extended = "min",
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL
) {
	trakt_auto_lists(
		list_type = "trending",
		type = "movies",
		limit = limit,
		extended = extended,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications
	)
}

#' @rdname trending_media
#' @eval apiurl("shows", "trending")
#' @family shows data
#' @family dynamic lists
#' @export
shows_trending <- function(
	limit = 10,
	extended = "min",
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL,
	networks = NULL,
	status = NULL
) {
	trakt_auto_lists(
		list_type = "trending",
		type = "shows",
		limit = limit,
		extended = extended,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications,
		networks = networks,
		status = status
	)
}

# Anticipated ----

#' Anticipated media
#'
#' These functions return the most anticipated movies/shows on trakt.tv.
#' @name anticipated_media
#' @inheritParams trakt_api_common_parameters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "anticipated")
#' @family movie data
#' @family dynamic lists
movies_anticipated <- function(
	limit = 10,
	extended = "min",
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL
) {
	trakt_auto_lists(
		list_type = "anticipated",
		type = "movies",
		limit = limit,
		extended = extended,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications
	)
}

#' @rdname anticipated_media
#' @export
#' @eval apiurl("shows", "anticipated")
#' @family shows data
#' @family dynamic lists
#' @examplesIf trakt_api_available()
#' # Get 15 the most anticipated upcoming shows on Netflix that air this year
#' current_year <- format(Sys.Date(), "%Y")
#' shows_anticipated(
#'   limit = 15,
#'   filters = filters_shows(networks = "Netflix", years = current_year)
#' )
shows_anticipated <- function(
	limit = 10,
	extended = "min",
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL,
	networks = NULL,
	status = NULL
) {
	trakt_auto_lists(
		list_type = "anticipated",
		type = "shows",
		limit = limit,
		extended = extended,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications,
		networks = networks,
		status = status
	)
}

# Played ----

#' Most played media
#'
#' These functions return the most played movies/shows on trakt.tv.
#' @name played_media
#' @inheritParams trakt_api_common_parameters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "played")
#' @family movie data
#' @family dynamic lists
movies_played <- function(
	limit = 10,
	extended = "min",
	period = c("weekly", "monthly", "yearly", "all"),
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL
) {
	period <- match.arg(period)

	trakt_auto_lists(
		list_type = "played",
		type = "movies",
		limit = limit,
		extended = extended,
		period = period,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications
	)
}

#' @rdname played_media
#' @eval apiurl("shows", "played")
#' @family show data
#' @family dynamic lists
#' @export
shows_played <- function(
	limit = 10,
	extended = "min",
	period = c("weekly", "monthly", "yearly", "all"),
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL,
	networks = NULL,
	status = NULL
) {
	period <- match.arg(period)

	trakt_auto_lists(
		list_type = "played",
		type = "shows",
		limit = limit,
		extended = extended,
		period = period,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications,
		networks = networks,
		status = status
	)
}

# Watched ----

#' Most watched media
#'
#' These functions return the most watched movies/shows on trakt.tv.
#' @name watched_media
#' @inheritParams trakt_api_common_parameters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "watched")
#' @family movie data
#' @family dynamic lists
movies_watched <- function(
	limit = 10,
	extended = "min",
	period = c("weekly", "monthly", "yearly", "all"),
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL
) {
	period <- match.arg(period)

	trakt_auto_lists(
		list_type = "watched",
		type = "movies",
		limit = limit,
		extended = extended,
		period = period,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications
	)
}

#' @rdname watched_media
#' @eval apiurl("shows", "watched")
#' @family shows data
#' @family dynamic lists
#' @export
shows_watched <- function(
	limit = 10,
	extended = "min",
	period = c("weekly", "monthly", "yearly", "all"),
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL,
	networks = NULL,
	status = NULL
) {
	period <- match.arg(period)

	trakt_auto_lists(
		list_type = "watched",
		type = "shows",
		limit = limit,
		extended = extended,
		period = period,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications,
		networks = networks,
		status = status
	)
}

# Collected ----

#' Most collected media
#'
#' These functions return the most collected movies/shows on trakt.tv.
#' @name collected_media
#' @inheritParams trakt_api_common_parameters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "collected")
#' @family movie data
#' @family dynamic lists
movies_collected <- function(
	limit = 10,
	extended = "min",
	period = c("weekly", "monthly", "yearly", "all"),
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL
) {
	period <- match.arg(period)

	trakt_auto_lists(
		list_type = "collected",
		type = "movies",
		limit = limit,
		extended = extended,
		period = period,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications
	)
}

#' @rdname collected_media
#' @eval apiurl("shows", "collected")
#' @family show data
#' @family dynamic lists
#' @export
shows_collected <- function(
	limit = 10,
	extended = "min",
	period = c("weekly", "monthly", "yearly", "all"),
	filters = NULL,
	query = NULL,
	years = NULL,
	genres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	ratings = NULL,
	certifications = NULL,
	networks = NULL,
	status = NULL
) {
	period <- match.arg(period)

	trakt_auto_lists(
		list_type = "collected",
		type = "shows",
		limit = limit,
		extended = extended,
		period = period,
		filters = filters,
		query = query,
		years = years,
		genres = genres,
		languages = languages,
		countries = countries,
		runtimes = runtimes,
		ratings = ratings,
		certifications = certifications,
		networks = networks,
		status = status
	)
}

# Updates ----

# Recently updated ----

#' Recently updated media
#'
#' Return movies or shows that were updated on trakt.tv since `start_date`.
#' Handy for keeping a local cache in sync: store the most recent `updated_at`
#' you have seen and poll for anything newer.
#'
#' @inheritParams trakt_api_common_parameters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @inherit trakt_api_common_parameters return
#' @param start_date `Date | character(1)`: Return items updated since this
#'   date. Defaults to yesterday. The trakt.tv API only accepts dates up to
#'   **30 days** in the past; older dates return no results (a warning is
#'   emitted).
#' @name updated_media
#' @note Unlike the other dynamic lists, the updates endpoints do not support
#'   the `filters` argument.
#' @examplesIf trakt_api_available()
#' movies_updates()
#' shows_updates(start_date = Sys.Date() - 7)
NULL

#' @rdname updated_media
#' @eval apiurl("movies", "updates")
#' @family movie data
#' @family dynamic lists
#' @export
movies_updates <- function(limit = 10, extended = "min", start_date = Sys.Date() - 1) {
	trakt_auto_lists(
		list_type = "updates",
		type = "movies",
		limit = limit,
		extended = extended,
		start_date = check_update_start_date(start_date)
	)
}

#' @rdname updated_media
#' @eval apiurl("shows", "updates")
#' @family show data
#' @family dynamic lists
#' @export
shows_updates <- function(limit = 10, extended = "min", start_date = Sys.Date() - 1) {
	trakt_auto_lists(
		list_type = "updates",
		type = "shows",
		limit = limit,
		extended = extended,
		start_date = check_update_start_date(start_date)
	)
}

# Coerce and validate the updates `start_date` (max 30 days in the past).
#' @keywords internal
#' @noRd
check_update_start_date <- function(start_date, call = rlang::caller_env()) {
	date <- tryCatch(as.Date(start_date), error = function(e) as.Date(NA))
	if (length(date) != 1 || is.na(date)) {
		cli::cli_abort(
			"{.arg start_date} must be a single date or {.val YYYY-MM-DD} string.",
			call = call
		)
	}
	if (date < Sys.Date() - 30) {
		cli::cli_warn(c(
			"{.arg start_date} ({.val {as.character(date)}}) is more than 30 days in the past.",
			"i" = "The trakt.tv API only returns updates from the last 30 days; older dates yield no results."
		))
	}
	as.character(date)
}
