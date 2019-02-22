#' Search for a show via text query
#'
#' `trakt.search` returns search result info.
#'
#' Search for a show or movie with a keyword (e.g. `"Breaking Bad"`) and receive basic info of the first
#' search result. It's main use is to retrieve the ids or proper show/movie title for further use, as well
#' as receiving a quick overview of a show/movie.
#' @param query The keyword used for the search. If the query ends with a 4 digit numbers,
#' this will be used as `year` parameter.
#' @param type The type of data you're looking for. Defaults to `show`, can also be
#'   `movie`, `episode`, `person` or `list`.
#' @param year Optionally filter by year.
#' @return A [tibble][tibble::tibble-package] containing a single search result. 
#'         If no results are found, the `tibble` has 0 rows.
#' @export
#' @importFrom stringr str_match
#' @importFrom stringr str_replace
#' @importFrom stringr str_trim
#' @note See \href{http://docs.trakt.apiary.io/reference/search/text-query}{the trakt API docs for
#'   further info}
#' @family API-basics
#' @family search functions
#' @examples
#' \dontrun{
#' breakingbad <- trakt.search("Breaking Bad")
#' }
trakt.search <- function(query, type = "show", year = NULL) {

  # Parse query for possible year
  if (is.null(year) & !(is.na(stringr::str_match(query, "(\\d{4})$")[1]))) {
    year <- stringr::str_match(query, "(\\d{4})$")[1]
    query <- stringr::str_replace(query, "(\\d{4})$", "")
    query <- stringr::str_trim(query)
  }

  # Construct URL, make API call
  url <- build_trakt_url("search", query = query, type = type, year = year)
  response <- trakt.api.call(url = url)

  if (identical(response, data.frame())) {
    warning("No results for query '", query, "'")
    return(tibble::tibble())
  }

  response <- response[[type]]
  response <- response[names(response) != "images"]
  response <- cbind(response[names(response) != "ids"], response$ids)
  response <- response[1, ]

  tibble::as_tibble(response)
}

#' Lookup a show via id
#'
#' `trakt.search.byid` pulls show stats and returns it compactly.
#'
#' @param id The id used for the search. Will be `URLencode`'d.
#' @param id_type The type of `id`. Defaults to `trakt-show`, can be
#' `trakt-movie`, `trakt-show`, `trakt-episode`, `imdb`,
#' `tmdb`, `tvdb`, `tvrage`
#' @return A [tibble][tibble::tibble-package] containing a single search result. 
#'         If no results are found, the `tibble` has 0 rows.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/search/id-lookup/get-id-lookup-results}{the trakt API docs for further info}
#' @family API-basics
#' @family search functions
#' @examples
#' \dontrun{
#' breakingbad <- trakt.search.byid(1388, "trakt-show")
#' }
trakt.search.byid <- function(id, id_type = "trakt-show") {

  # Construct URL, make API call
  url <- build_trakt_url("search", id_type = id_type, id = id)
  response <- trakt.api.call(url = url)

  # Check if response is empty (nothing found)
  if (identical(response, data.frame())) {
    warning("No results for id '", id, "' (", id_type, ")")
    return(tibble::tibble())
  }

  response <- response[[ncol(response)]]
  response <- response[names(response) != "images"]
  response <- cbind(response[names(response) != "ids"], response$ids)

  tibble::as_tibble(response)
}
