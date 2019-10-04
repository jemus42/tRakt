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

#' Get items from fanart.tv
#'
#' This requires a valid API key in the environment variable `fanarttv_api_key`, which you can
#' set in your `~/.Renviron`. You can create an API key [on fanart.tv](https://fanart.tv/get-an-api-key/).
#'
#' @param tvdb `[character(1)]`: A valid `tvdb` id.
#'
#' @return A [tibble()][tibble::tibble-package] with multiple list-columns.
#' @keywords internal
#' @noRd
#' @importFrom httr modify_url GET content
#' @importFrom purrr map
#' @importFrom tibble tibble as_tibble
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_cols
#' @examples
#' \dontrun{
#' fanarttv_get(tvdb = "81189")
#' }
fanarttv_get <- function(tvdb) {
  url <- modify_url(
    url = "http://webservice.fanart.tv",
    path = paste0("v3/tv/", tvdb),
    query = list(api_key = Sys.getenv("fanarttv_api_key"))
  )

  res <- GET(url)
  res <- fromJSON(content(res, as = "text"))
  res <- map(res, as_tibble)

  res_x <- tibble(
    name = res$name$value,
    tvdb = res$thetvdb_id$value
  )

  res_y <- res[!(names(res) %in% c("name", "thetvdb_id"))] %>%
    map(~ list(.x)) %>%
    as_tibble()

  bind_cols(res_x, res_y)
}
