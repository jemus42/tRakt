#' Search for a show via text query or id
#'
#' Search for a show or movie with a keyword (e.g. `"Breaking Bad"`) and receive
#' basic info of the first search result. It's main use is to retrieve
#' the ids or proper show/movie title for further use, as well
#' as receiving a quick overview of a show/movie.
#'
#' The amount of
#' information returned is equal to `.summary` API methods and in turn depends on
#' the value of `extended`.
#' See also [the API reference here](https://trakt.docs.apiary.io/#reference/search) for
#' which fields of the item metadata are searched by default.
#' @param query `character(1)`: The keyword used for the search, e.g. `"breaking bad"`.
#' @param id `character(1)`: The id used for the search, e.g. `14701` for a `Trakt ID`.
#' @param id_type `character(1) ["trakt"]`: The type of `id`. One of `trakt`, `imdb`, `tmdb`, `tvdb`.
#' @param type `character(1) ["show"]`: The type of data you're looking for. One of `show`,
#' `movie`, `episode`, `person` or `list` or a character vector with those elements, e.g.
#' `c("show", "movie")`. Note that not every combination is reasonably combinable, e.g.
#' `c("movie", "list")`. Use separate function calls in that case.
#' @inheritParams search_filters
#' @param n_results `integer(1) [1]`: How many results to return.
#' @return A [tibble()][tibble::tibble-package] containing a `n_result` result.
#'         If no results are found, the `tibble` has 0 rows.
#' @inheritParams trakt_api_common_parameters
#' @export
#' @family API-basics
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#' @examples
#' # A show
#' trakt.search("Breaking Bad", type = "show", n_results = 3)
#' \dontrun{
#' # A show by its trakt id, and now with more information
#' trakt.search.byid(1388, "trakt", type = "show", extended = "full")
#'
#' # A person
#' trakt.search("J. K. Simmons", type = "person", extended = "full")
#'
#' # A movie or a show, two of each
#' trakt.search("Tron", type = c("movie", "show"), n_results = 2)
#' }
trakt.search <- function(query, type = "show",
                         years = NULL, n_results = 1L, extended = c("min", "full")) {

  ok_types <- c("movie", "show", "episode", "person", "list")
  type <- match.arg(type, choices = ok_types, several.ok = TRUE)
  extended <- match.arg(extended)
  years <- check_filter_arg(years, "years")

  if (length(type) > 1) {
    return(map_df(type, ~ trakt.search(query, type = .x, years, n_results, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("search", type, query = query, years = years, extended = extended)
  response <- trakt_get(url = url)

  if (identical(response, tibble())) {
    warning("No results for query '", query, "'")
    return(response)
  }

  search_result_cleanup(response, type, n_results, extended)
}

#' @rdname trakt.search
#' @export
trakt.search.byid <- function(id, id_type = c("trakt", "imdb", "tmdb", "tvdb"),
                              type = "movie",
                              n_results = 1L, extended = c("min", "full")) {
  id_type <- match.arg(id_type)
  ok_types <- c("movie", "show", "episode", "person", "list")
  type <- match.arg(type, choices = ok_types, several.ok = TRUE)
  extended <- match.arg(extended)

  if (length(type) > 1) {
    return(map_df(type, ~ trakt.search.byid(id, id_type, type = .x, n_results, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("search", id_type, id, type = type, extended = extended)
  response <- trakt_get(url = url)

  # Check if response is empty (nothing found)
  if (identical(response, tibble::tibble())) {
    warning("No results for id '", id, "' (", id_type, ")")
    return(tibble::tibble())
  }

  search_result_cleanup(response, type, n_results, extended)
}

#' Search helper function
#' @keywords internal
#' @importFrom utils head
#' @importFrom tibble has_name
#' @importFrom tibble as_tibble
#' @importFrom tibble remove_rownames
#' @noRd
search_result_cleanup <- function(response, type, n_results, extended) {

  # Just to be really safe it's always a numeric
  response$score <- as.numeric(response$score)

  if (type == "show" & extended == "full") {
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

  head(response, n_results) %>%
    fix_tibble_response()
}
