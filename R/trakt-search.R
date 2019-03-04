#' Search for a show via text query or id
#'
#' Search for a show or movie with a keyword (e.g. `"Breaking Bad"`) and receive
#' basic info of the first search result. It's main use is to retrieve
#' the ids or proper show/movie title for further use, as well
#' as receiving a quick overview of a show/movie. The amount of
#' information returned is equal to `.summary` API methods and also depends on
#' the value of `extended`.
#' @param query The keyword used for the search.
#' @param id The id used for the search.
#' @param id_type The type of `id`. One of `trakt` (default), `imdb`, `tmdb`, `tvdb`.
#' @param type `character(1) ["movie"]`: The type of data you're looking for. One of `show`,
#' `movie`, `episode`, `person` or `list` or a character vector with those elements, e.g.
#' `c("show", "movie")`. Note that not every combination is reasonably combinable, e.g.
#' `c("movie", "list")`. Use separate function calls in that case.
#' @param years Optionally filter by years.
#' @param n_results `integer(1) [1]`: How many results to return.
#' @return A [tibble()][tibble::tibble-package] containing a `n_result` result.
#'         If no results are found, the `tibble` has 0 rows.
#' @inheritParams trakt_api_common_parameters
#' @export
#' @source [The trakt.tv API docs](https://trakt.docs.apiary.io/#reference/search/text-query/get-text-query-results)
#' @family API-basics
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#' @examples
#' # A show
#' trakt.search("Breaking Bad", type = "show", n_results = 3)
#'
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
trakt.search <- function(query, type = c("movie", "show", "episode", "person", "list"),
                         years = NULL, n_results = 1L, extended = c("min", "full")) {
  type <- match.arg(type, several.ok = TRUE)
  extended <- match.arg(extended)

  if (length(type) > 1) {
    return(map_df(type, ~trakt.search(query, type = .x, years, n_results, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("search", type, query = query, years = years, extended = extended)
  response <- trakt.api.call(url = url)

  if (identical(response, tibble())) {
    warning("No results for query '", query, "'")
    return(response)
  }

  search_result_cleanup(response, type, n_results, extended)
}

#' @rdname trakt.search
#' @export
trakt.search.byid <- function(id, id_type = c("trakt", "imdb", "tmdb", "tvdb"),
                              type = c("movie", "show", "episode", "person", "list"),
                              n_results = 1L, extended = c("min", "full")) {
  id_type <- match.arg(id_type)
  type <- match.arg(type)
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url("search", id_type, id, type = type, extended = extended)
  response <- trakt.api.call(url = url)

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
#' @noRd
search_result_cleanup <- function(response, type, n_results, extended) {

  # Just to be really safe it's always a numeric
  response$score <- as.numeric(response$score)

  if (type == "show" & extended == "full") {
    response$show <- unpack_show(response$show)
  }

  response <- cbind(response[names(response) != type], response[[type]])

  # Already handled by unpack_show so it would fail here
  if (tibble::has_name(response, "ids")) {
    response <- cbind(response[names(response) != "ids"], fix_ids(response$ids))
  }

  # Sanity filter: Remove items with a year of NA, like "show" + "tron"
  # Happens for exact title matches (bumps "score") but e.g. false type in this case
  response <- tibble::as_tibble(response)
  if (tibble::has_name(response, "year")) {
    response <- response[!(is.na(response$year) & response$score == 1000), ]
  }

  utils::head(response, n_results)
}
