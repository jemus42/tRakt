#' Search trakt.tv via text query or ID
#'
#' Search for a show or movie with a keyword (e.g. `"Breaking Bad"`) and receive
#' basic info of the first search result. It's main use is to retrieve
#' the IDs or proper show/movie title for further use, as well
#' as receiving a quick overview of a show/movie.
#'
#' The amount of information returned is equal to `*_summary` API methods and
#' in turn depends on the value of `extended`.
#' See also the
#' [API reference here](https://trakt.docs.apiary.io/#reference/search) for
#' which fields of the item metadata are searched by default.
#' @inheritParams trakt_api_common_parameters
#' @param id `character(1)`: The id used for the search, e.g. `14701` for
#'   a `Trakt ID`.
#' @param id_type `character(1) ["trakt"]`: The type of `id`. One of `trakt`,
#'   `imdb`, `tmdb`, `tvdb`.
#' @param type `character(1) ["show"]`: The type of data you're looking for.
#'   One of `show`, `movie`, `episode`, `person` or `list` or a character vector
#'   with those elements, e.g. `c("show", "movie")`. Note that not every
#'   combination is reasonably combinable, e.g. `c("movie", "list")`. Use
#'   separate function calls in that case.
#' @inheritParams trakt_api_common_parameters
#' @param n_results `integer(1) [1]`: How many results to return.
#' @return A [tibble][tibble::tibble-package] containing `n_results` results.
#'         Variable `type` is equivalent to the value of the `type` argument, and
#'         variable `score` indicates the search match, where `1000` is a perfect
#'         match.
#'         If no results are found, the `tibble` has 0 rows.
#'         If more than one `type` is specified, e.g. `c("movie", "show")`,
#'         there will be `n_results` results *per type*.
#' @export
#' @family search functions
#' @eval apiurl("search", "text query")
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#' @examples
#' # A show
#' search_query("Breaking Bad", type = "show", n_results = 3)
#' \dontrun{
#' # A show by its trakt id, and now with more information
#' search_id(1388, "trakt", type = "show", extended = "full")
#'
#' # A person
#' search_query("J. K. Simmons", type = "person", extended = "full")
#'
#' # A movie or a show, two of each
#' search_query("Tron", type = c("movie", "show"), n_results = 2)
#' }
search_query <- function(query, type = "show",
                         n_results = 1L,
                         extended = c("min", "full"),
                         years = NULL,
                         genres = NULL, languages = NULL,
                         countries = NULL, runtimes = NULL,
                         ratings = NULL, certifications = NULL,
                         networks = NULL, status = NULL) {
  if (length(type) > 1) {
    res <- map_df(type, ~ search_query(
      query,
      type = .x,
      n_results = n_results,
      years = years,
      extended = extended, genres = genres, languages = languages,
      countries = countries, runtimes = runtimes, ratings = ratings,
      certifications = certifications, networks = networks, status = status
    ))
    return(res)
  }
  ok_types <- c("movie", "show", "episode", "person", "list")
  type <- check_types(type, several.ok = TRUE, possible_types = ok_types)

  extended <- match.arg(extended)

  # Check filters
  query <- check_filter_arg(query, "query")
  years <- check_filter_arg(years, "years")
  genres <- check_filter_arg(genres, "genres")
  languages <- check_filter_arg(languages, "languages")
  countries <- check_filter_arg(countries, "countries")
  runtimes <- check_filter_arg(runtimes, "runtimes")
  ratings <- check_filter_arg(ratings, "ratings")
  certifications <- check_filter_arg(certifications, "certifications")
  networks <- check_filter_arg(networks, "networks")
  status <- check_filter_arg(status, "status")

  # Construct URL, make API call
  url <- build_trakt_url("search", type,
    query = query, years = years,
    extended = extended, genres = genres, languages = languages,
    countries = countries, runtimes = runtimes, ratings = ratings,
    certifications = certifications, networks = networks, status = status
  )
  response <- trakt_get(url = url)

  if (identical(response, tibble())) {
    warning("No results for query '", query, "'")
    return(response)
  }

  search_result_cleanup(response, type, n_results, extended)
}

#' @rdname search_query
#' @family search functions
#' @eval apiurl("search", "ID lookup")
#' @export
search_id <- function(id, id_type = c("trakt", "imdb", "tmdb", "tvdb"),
                      type = "show",
                      n_results = 1L, extended = c("min", "full")) {
  if (length(type) > 1) {
    return(map_df(type, ~ search_id(id, id_type, type = .x, n_results, extended)))
  }

  id_type <- match.arg(id_type)
  ok_types <- c("movie", "show", "episode", "person", "list")
  type <- check_types(type, several.ok = TRUE, possible_types = ok_types)
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url("search", id_type, id, type = type, extended = extended)
  response <- trakt_get(url = url)

  # Check if response is empty (nothing found)
  if (identical(response, tibble())) {
    warning("No results for id '", id, "' (", id_type, ")")
    return(tibble())
  }

  search_result_cleanup(response, type, n_results, extended)
}

#' Search helper function
#' @keywords internal
#' @importFrom utils head
#' @importFrom rlang has_name
#' @importFrom tibble as_tibble
#' @importFrom tibble remove_rownames
#' @noRd
search_result_cleanup <- function(response, type, n_results, extended) {
  # Just to be really safe it's always a numeric
  response$score <- as.numeric(response$score)

  if (type == "show" && extended == "full") {
    response$show <- unpack_show(response$show)
  }

  response <- cbind(response[names(response) != type], response[[type]])

  # Already handled by unpack_show so it would fail here
  if (has_name(response, "ids")) {
    response <- cbind(response[names(response) != "ids"], fix_ids(response$ids))
  }

  # Sanity filter: Bump down items with a year of NA, like "show" + "tron"
  # Happens for exact title matches (bumps "score") but e.g. false type in this case
  response <- as_tibble(response)
  if (has_name(response, "year")) {
    response[is.na(response$year) & response$score == 1000, "score"] <- 20
    response <- response[order(response$score, decreasing = TRUE), ]
  }

  head(response, n_results) |>
    fix_tibble_response()
}
