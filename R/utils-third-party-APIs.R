# nocov start

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
#' @inherit trakt_api_common_parameters return
#' @keywords internal
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble tibble
#' @examples
#' \dontrun{
#' omdb_get("tt0903747")
#' }
omdb_get <- function(imdb) {
  res <- httr2::request("https://www.omdbapi.com/") |>
    httr2::req_url_query(i = imdb, apikey = Sys.getenv("OMDB_API_KEY")) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)

  if (identical(res$Response, "False")) {
    warning(imdb, ": ", res$Error)
    return(tibble())
  }

  res <- dplyr::bind_cols(
    res[which(names(res) != "Ratings")],
    rating_rotten_tomatoes = res$Ratings$Value[[1]],
    rating_imdb = res$Ratings$Value[[2]]
  )

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
#' @importFrom purrr map
#' @importFrom tibble tibble as_tibble
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_cols
#' @examples
#' \dontrun{
#' fanarttv_get(tvdb = "81189")
#' }
fanarttv_get <- function(tvdb) {

  res <- httr2::request("http://webservice.fanart.tv") |>
    httr2::req_url_path_append("v3/tv", tvdb) |>
    httr2::req_url_query(api_key = Sys.getenv("fanarttv_api_key")) |>
    httr2::req_perform()

  res <- httr2::resp_body_json(res, simplifyVector = TRUE)
  res <- lapply(res, as_tibble)

  res_x <- tibble(
    name = res$name$value,
    tvdb = res$thetvdb_id$value
  )

  res_y <- res[!(names(res) %in% c("name", "thetvdb_id"))] |>
    map(~ list(.x)) |>
    as_tibble()

  bind_cols(res_x, res_y)
}
# nocov end
