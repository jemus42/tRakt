#' Search for a show via text query
#'
#' \code{trakt.search} pulls show stats and returns it compactly.
#'
#' Search for a show with a keyword (e.g. \code{"Breaking Bad"}) and receive basic info of the first
#' search result. It's main use is to retrieve the ids or proper show title for further use, as well
#' as receiving a quick overview of a show.
#' @param query The keyword used for the search. Will be coerced to \code{character} and
#' \code{URLencode}d. If the query ends with a 4 digit numbers, this will be used as
#' \code{year} parameter.
#' @param type The type of data you're looking for. Defaults to \code{show}, can also be
#'   \code{movie}, \code{episode}, \code{person} or \code{list}.
#' @param year Optionally filter by year.
#' @return A \code{data.frame} containing a single search result. Hopefully the one you wanted. If
#'   no result is found, the return value is \code{list(error = "Nothing found")} and a
#'   \code{warning}
#' @export
#' @importFrom stringr str_match
#' @importFrom stringr str_replace
#' @importFrom stringr str_trim
#' @note See \href{http://docs.trakt.apiary.io/reference/search/text-query}{the trakt API docs for
#'   further info}
#' @family API, search
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad <- trakt.search("Breaking Bad")
#' }
trakt.search <- function(query, type = "show", year = NULL){

  # Parse query for possible year
  if (is.null(year) & !(is.na(stringr::str_match(query, "(\\d{4})$")[1]))){
    year  <- stringr::str_match(query, "(\\d{4})$")[1]
    query <- stringr::str_replace(query, "(\\d{4})$", "")
    query <- stringr::str_trim(query)
  }

  # Construct URL, make API call
  query    <- as.character(query) # Just to make sure…
  query    <- URLencode(query)    # URL normalization
  baseURL  <- "https://api-v2launch.trakt.tv/search"
  url      <- paste0(baseURL, "?query=", query, "&type=", type, "&year=", year)
  response <- trakt.api.call(url = url, convert.datetime = F)

  # Check if response is empty (nothing found)
  if (identical(response, list())){
    warning("No result, sorry.")
    return(list(error = "Nothing found"))
  }

  # Try to find the closest match via basic string comparison (Could use improvement)
  stringmatch <- match(tolower(URLdecode(query)), tolower(response[[type]]$title))

  # Cleanup received data, using only matched line
  if (is.na(stringmatch)){
    warning("No exact match found, using trakt.tv's best guess")
    result <- response[1, ][[type]]
  } else {
    result <- response[stringmatch, ][[type]]
  }

  return(result)
}
