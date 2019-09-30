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
    map(~list(.x)) %>%
    as_tibble()

  bind_cols(res_x, res_y)
}

