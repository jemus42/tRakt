#' Make an OMDb API call
#'
#' This requires a valid OMDb API key to be available in the environment
#' variable `OMDB_API_KEY`, which you can set in your `~/.Renviron`.
#' You can get an API key from [OMDb here](http://www.omdbapi.com/apikey.aspx).
#'
#' @details
#' This is only a basic implementation for direct look-up. For more
#' functionality, see [hrbrmstr/omdbapi](https://github.com/hrbrmstr/omdbapi).
#'
#' @param imdb `character(1)`: A valid `imdb` ID for a movie, show, or episode.
#' @noRd
#' @return A [tibble()](tibble::tibble-package).
#' @keywords internal
#' @importFrom httr modify_url GET content stop_for_status
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble tibble
#' @examples
#' \dontrun{
#' omdb_get("tt0903747")
#' }
omdb_get <- function(imdb) {
  base_url <- modify_url("https://www.omdbapi.com/",
    query = list(apikey = Sys.getenv("OMDB_API_KEY"))
  )

  url <- modify_url(base_url, query = list(i = imdb))

  res <- GET(url)
  stop_for_status(res, "Getting data from OMDBapi")

  res <- content(res, as = "text")
  res <- fromJSON(res)

  if (identical(res$Response, "False")) {
    warning(imdb, ": ", res$Error)
    return(tibble())
  }

  res <- as_tibble(res)
  res <- res[names(res) != "Ratings"]
  res$imdbRating <- as.numeric(res$imdbRating)
  res$imdbVotes <- as.numeric(gsub(",", "", res$imdbVotes))

  res
}
