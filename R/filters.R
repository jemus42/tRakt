# Filter specification, validation, and builders for the trakt.tv "Filters"
# that apply to the dynamic-list (`movies_popular()` etc.) and `search_*()`
# endpoints. See the "Filters" section of the API docs:
# <https://trakt.docs.apiary.io/#introduction/filters>.
#
# The single source of truth is `trakt_filter_registry()`. Adding or updating a
# filter is a one-line change there; the builders and validators are driven by
# it.

# ---- Registry --------------------------------------------------------------

#' Specification of every supported trakt.tv filter
#'
#' Each entry describes one filter: the query-parameter name sent to the API
#' (`api`), the validator `kind`, and any parameters that validator needs
#' (numeric `min`/`max`/`decimals` for ranges, a `vocab` thunk for
#' fixed-vocabulary filters). Vocabularies backed by bundled data are wrapped in
#' a function so they are resolved lazily.
#'
#' @keywords internal
#' @noRd
trakt_filter_registry <- function() {
	list(
		# Common filters
		query = list(api = "query", kind = "free"),
		years = list(api = "years", kind = "year"),
		genres = list(api = "genres", kind = "vocab", vocab = function() tRakt::trakt_genres$slug),
		subgenres = list(api = "subgenres", kind = "passthrough"),
		languages = list(
			api = "languages",
			kind = "vocab",
			vocab = function() tRakt::trakt_languages$code
		),
		countries = list(
			api = "countries",
			kind = "vocab",
			vocab = function() tRakt::trakt_countries$code
		),
		runtimes = list(api = "runtimes", kind = "range", min = 0, max = Inf, decimals = FALSE),
		studio_ids = list(api = "studio_ids", kind = "ids"),
		# Rating filters
		ratings = list(api = "ratings", kind = "range", min = 0, max = 100, decimals = FALSE),
		votes = list(api = "votes", kind = "range", min = 0, max = 100000, decimals = FALSE),
		tmdb_ratings = list(api = "tmdb_ratings", kind = "range", min = 0, max = 10, decimals = TRUE),
		tmdb_votes = list(api = "tmdb_votes", kind = "range", min = 0, max = 100000, decimals = FALSE),
		imdb_ratings = list(api = "imdb_ratings", kind = "range", min = 0, max = 10, decimals = TRUE),
		imdb_votes = list(api = "imdb_votes", kind = "range", min = 0, max = 3000000, decimals = FALSE),
		rt_meters = list(api = "rt_meters", kind = "range", min = 0, max = 100, decimals = FALSE),
		rt_user_meters = list(
			api = "rt_user_meters",
			kind = "range",
			min = 0,
			max = 100,
			decimals = FALSE
		),
		metascores = list(api = "metascores", kind = "range", min = 0, max = 100, decimals = TRUE),
		# Type-specific filters
		certifications = list(
			api = "certifications",
			kind = "vocab",
			vocab = function() tRakt::trakt_certifications$slug
		),
		network_ids = list(api = "network_ids", kind = "ids"),
		networks = list(
			api = "networks",
			kind = "networks",
			vocab = function() tRakt::trakt_networks$name
		),
		status = list(
			api = "status",
			kind = "vocab",
			vocab = function() {
				c(
					"returning series",
					"continuing",
					"in production",
					"planned",
					"upcoming",
					"pilot",
					"canceled",
					"ended"
				)
			}
		),
		episode_types = list(
			api = "episode_types",
			kind = "vocab",
			vocab = function() {
				c(
					"standard",
					"series_premiere",
					"season_premiere",
					"mid_season_finale",
					"mid_season_premiere",
					"season_finale",
					"series_finale"
				)
			}
		)
	)
}

# Which filters each media context exposes, per the API docs. The "any" context
# accepts every known filter and is used when validating legacy flat arguments
# for endpoints (like search) that span multiple media types.
trakt_filter_names <- function(
	context = c("movies", "shows", "episodes", "any")
) {
	context <- match.arg(context)

	if (context == "any") {
		return(names(trakt_filter_registry()))
	}

	common <- c(
		"query",
		"years",
		"genres",
		"subgenres",
		"languages",
		"countries",
		"runtimes",
		"studio_ids"
	)
	# Trakt/TMDB/IMDB ratings apply to movies, shows, and episodes.
	ratings_shared <- c(
		"ratings",
		"votes",
		"tmdb_ratings",
		"tmdb_votes",
		"imdb_ratings",
		"imdb_votes"
	)
	# Rotten Tomatoes and Metacritic apply to movies only.
	ratings_movies <- c("rt_meters", "rt_user_meters", "metascores")

	switch(
		context,
		movies = c(common, ratings_shared, ratings_movies, "certifications"),
		shows = c(
			common,
			ratings_shared,
			"certifications",
			"network_ids",
			"networks",
			"status"
		),
		episodes = c(
			common,
			ratings_shared,
			"certifications",
			"network_ids",
			"episode_types"
		)
	)
}

# ---- Validators ------------------------------------------------------------

# Dispatch a single filter value to its validator. Returns a length-1 character
# query value, or NULL if the input is empty or fully invalid (with a warning).
validate_filter <- function(name, value, spec = trakt_filter_registry()[[name]]) {
	if (is.null(value) || (length(value) == 1 && identical(value, ""))) {
		return(NULL)
	}

	out <- switch(
		spec$kind,
		free = as.character(value)[[1]],
		year = check_filter_arg(value, "years"),
		range = filter_validate_range(value, name, spec$min, spec$max, spec$decimals),
		vocab = check_filter_arg_fixed(value, name, spec$vocab()),
		networks = check_filter_arg_fixed(value, name, spec$vocab()),
		ids = filter_validate_ids(value, name),
		passthrough = filter_validate_passthrough(value),
		cli::cli_abort("Unknown filter kind {.val {spec$kind}} for {.arg {name}}.")
	)

	if (is.null(out) || identical(out, "")) NULL else out
}

# Numeric range filter: accepts a single value, a length-2 numeric, or an
# "a-b"/"a" string; validates bounds and renders as "lo-hi" (or "v").
#' @importFrom rlang %||%
filter_validate_range <- function(x, name, min = 0, max = Inf, decimals = FALSE) {
	if (is.character(x) && length(x) == 1) {
		x <- strsplit(x, "-", fixed = TRUE)[[1]]
	}
	parts <- suppressWarnings(as.numeric(x))

	if (anyNA(parts) || !length(parts) %in% c(1L, 2L)) {
		cli::cli_warn(
			"{.arg {name}} must be a single number or a length-2 range; ignoring."
		)
		return(NULL)
	}
	if (any(parts < min | parts > max)) {
		cli::cli_warn(
			"{.arg {name}} values must be between {min} and {max}; ignoring."
		)
		return(NULL)
	}

	if (!decimals) {
		parts <- as.integer(round(parts))
	}
	paste0(sort(parts), collapse = "-")
}

# Numeric-ID filter (studio_ids, network_ids): positive integers, comma-joined.
filter_validate_ids <- function(x, name) {
	x <- unlist(strsplit(as.character(x), ",", fixed = TRUE))
	ids <- suppressWarnings(as.integer(trimws(x)))

	if (anyNA(ids)) {
		cli::cli_warn(
			"{.arg {name}} must be integer IDs; ignoring non-integer value{?s}: {.val {x[is.na(ids)]}}."
		)
		ids <- ids[!is.na(ids)]
	}
	ids <- ids[ids >= 1]

	if (length(ids) == 0) {
		return(NULL)
	}
	paste0(unique(ids), collapse = ",")
}

# Free-form multi-value filter (subgenres, technical preview): trim + comma-join.
filter_validate_passthrough <- function(x) {
	x <- trimws(unlist(strsplit(as.character(x), ",", fixed = TRUE)))
	x <- x[nzchar(x)]
	if (length(x) == 0) {
		return(NULL)
	}
	paste0(unique(x), collapse = ",")
}

# ---- Object ----------------------------------------------------------------

#' Construct a validated `trakt_filters` object
#'
#' @param params Named list keyed by API query-parameter name.
#' @keywords internal
#' @noRd
#' @importFrom purrr compact
new_trakt_filters <- function(params = list()) {
	params <- compact(params)
	structure(params, class = "trakt_filters")
}

# Build a `trakt_filters` object from a builder's arguments.
build_trakt_filters <- function(context, args) {
	registry <- trakt_filter_registry()
	allowed <- trakt_filter_names(context)

	out <- list()
	for (nm in names(args)) {
		value <- args[[nm]]
		if (is.null(value)) {
			next
		}
		if (!nm %in% allowed) {
			# Programming error rather than user error: builders only expose
			# allowed names, so this guards internal misuse.
			cli::cli_abort("{.val {nm}} is not a valid filter for {.val {context}}.")
		}
		spec <- registry[[nm]]
		out[[spec$api]] <- validate_filter(nm, value, spec)
	}
	new_trakt_filters(out)
}

#' @export
print.trakt_filters <- function(x, ...) {
	if (length(x) == 0) {
		cli::cli_text("{.cls trakt_filters} (empty)")
		return(invisible(x))
	}
	cli::cli_text("{.cls trakt_filters}")
	for (nm in names(x)) {
		cli::cli_li("{.field {nm}}: {.val {x[[nm]]}}")
	}
	invisible(x)
}

# Reconcile the new `filters` argument with the legacy individual filter
# arguments. Rules (agreed for #36):
#   * No flat args           -> use `filters` (or an empty set).
#   * Flat args, no `filters` -> soft-deprecation warning; build a filter set
#                                from them so existing code keeps working.
#   * Flat args AND `filters` -> warn that both were supplied; `filters` wins.
# `flat` is a named list of the legacy arguments (NULLs are dropped here).
#' @importFrom purrr compact
resolve_filters <- function(
	filters,
	flat,
	context = c("movies", "shows", "episodes", "any"),
	user_env = rlang::caller_env()
) {
	context <- match.arg(context)
	flat <- compact(flat)

	if (length(flat) == 0) {
		return(as_trakt_filters(filters))
	}

	builder <- switch(
		context,
		movies = "filters_movies",
		episodes = "filters_episodes",
		"filters_shows"
	)
	lifecycle::deprecate_soft(
		when = "0.20.0",
		what = I("Passing filters as individual arguments (e.g. `genres`, `years`, `networks`)"),
		details = c(
			i = "Use the {.arg filters} argument with a builder instead:",
			"*" = sprintf("filters = %s(%s = ...)", builder, names(flat)[[1]])
		),
		user_env = user_env
	)

	if (!is.null(filters)) {
		cli::cli_warn(c(
			"!" = "Both {.arg filters} and individual filter arguments were supplied.",
			"i" = "Using {.arg filters}; the individual arguments are ignored."
		))
		return(as_trakt_filters(filters))
	}

	build_trakt_filters(context, flat)
}

# Coerce assorted user input into a `trakt_filters` object (used internally by
# the endpoint functions): passes a `trakt_filters` through untouched, and
# treats NULL / empty as "no filters".
as_trakt_filters <- function(filters) {
	if (is.null(filters)) {
		return(new_trakt_filters())
	}
	if (!inherits(filters, "trakt_filters")) {
		cli::cli_abort(c(
			"{.arg filters} must be a {.cls trakt_filters} object or {.code NULL}.",
			"i" = "Create one with {.fn filters_movies}, {.fn filters_shows}, or {.fn filters_episodes}."
		))
	}
	filters
}

# ---- Builders --------------------------------------------------------------

#' Build a filter set for the dynamic-list and search endpoints
#'
#' The trakt.tv API lets several `movies`, `shows`, and `search` methods refine
#' their results with *filters*. These builders assemble a validated set of
#' filters to pass to the `filters` argument of functions like
#' [movies_popular()], [shows_trending()], or [search_query()].
#'
#' Each builder exposes exactly the filters the API supports for that media
#' type. Values are validated and normalized up front (unknown vocabulary values
#' warn and are dropped; out-of-range numbers warn and are ignored), so a
#' malformed filter never silently produces a wrong request.
#'
#' @param query `character(1)`: Match titles and descriptions.
#' @param years `numeric`: A single 4-digit year or a length-2 range, e.g.
#'   `2016` or `c(2000, 2010)`.
#' @param genres,languages,countries,certifications `character`: One or more
#'   [genre slugs][trakt_genres], [language codes][trakt_languages],
#'   [country codes][trakt_countries], or [certification slugs][trakt_certifications].
#' @param subgenres `character`: One or more subgenre slugs (technical preview).
#' @param runtimes `numeric`: Runtime in minutes; a single value or length-2
#'   range.
#' @param studio_ids,network_ids `integer`: One or more Trakt studio / network
#'   IDs.
#' @param ratings,votes `numeric`: Trakt rating (`0`-`100`) / vote-count
#'   (`0`-`100000`) range.
#' @param tmdb_ratings,tmdb_votes `numeric`: TMDB rating (`0.0`-`10.0`) /
#'   vote-count range.
#' @param imdb_ratings,imdb_votes `numeric`: IMDb rating (`0.0`-`10.0`) /
#'   vote-count range.
#' @param rt_meters,rt_user_meters `numeric`: Rotten Tomatoes tomatometer /
#'   audience-score range (`0`-`100`). Movies only.
#' @param metascores `numeric`: Metacritic score range (`0`-`100`). Movies only.
#' @param networks `character`: One or more network names (e.g. `"Netflix"`),
#'   validated against [trakt_networks]. For precise matching prefer
#'   `network_ids`.
#' @param status `character`: One or more show statuses: `"returning series"`,
#'   `"continuing"`, `"in production"`, `"planned"`, `"upcoming"`, `"pilot"`,
#'   `"canceled"`, `"ended"`.
#' @param episode_types `character`: One or more episode types: `"standard"`,
#'   `"series_premiere"`, `"season_premiere"`, `"mid_season_finale"`,
#'   `"mid_season_premiere"`, `"season_finale"`, `"series_finale"`.
#' @return A `trakt_filters` object: a validated, classed list of query
#'   parameters. Pass it to a function's `filters` argument.
#' @name filters
#' @family dynamic lists
#' @examples
#' filters_movies(genres = "action", years = c(2000, 2010), imdb_ratings = c(8, 10))
#'
#' filters_shows(networks = "Netflix", status = "returning series")
#'
#' filters_episodes(episode_types = "season_finale")
NULL

#' @rdname filters
#' @export
filters_movies <- function(
	query = NULL,
	years = NULL,
	genres = NULL,
	subgenres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	studio_ids = NULL,
	ratings = NULL,
	votes = NULL,
	tmdb_ratings = NULL,
	tmdb_votes = NULL,
	imdb_ratings = NULL,
	imdb_votes = NULL,
	rt_meters = NULL,
	rt_user_meters = NULL,
	metascores = NULL,
	certifications = NULL
) {
	build_trakt_filters("movies", as.list(environment()))
}

#' @rdname filters
#' @export
filters_shows <- function(
	query = NULL,
	years = NULL,
	genres = NULL,
	subgenres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	studio_ids = NULL,
	ratings = NULL,
	votes = NULL,
	tmdb_ratings = NULL,
	tmdb_votes = NULL,
	imdb_ratings = NULL,
	imdb_votes = NULL,
	certifications = NULL,
	network_ids = NULL,
	networks = NULL,
	status = NULL
) {
	build_trakt_filters("shows", as.list(environment()))
}

#' @rdname filters
#' @export
filters_episodes <- function(
	query = NULL,
	years = NULL,
	genres = NULL,
	subgenres = NULL,
	languages = NULL,
	countries = NULL,
	runtimes = NULL,
	studio_ids = NULL,
	ratings = NULL,
	votes = NULL,
	tmdb_ratings = NULL,
	tmdb_votes = NULL,
	imdb_ratings = NULL,
	imdb_votes = NULL,
	certifications = NULL,
	network_ids = NULL,
	episode_types = NULL
) {
	build_trakt_filters("episodes", as.list(environment()))
}
