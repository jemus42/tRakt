#' Easy episode number padding
#'
#' Simple function to ease the creation of `sXXeYY` episode ids.
#' Note that `s` and `e` must have the same length.
#' @param s Input season number, coerced to `character`.
#' @param e Input episode number, coerced to `character`.
#' @param s_width The length of the season number padding. Defaults to 2.
#' @param e_width The length of the episode number padding. Defaults to 2.
#' @return A `character` in the common `sXXeYY` format
#' @family utility functions
#' @note I like my sXXeYY format, okay?
#' @export
#' @examples
#' # Season 2, episode 4
#' pad_episode(2, 4)
#' pad_episode(1, 85, e_width = 3)
pad_episode <- function(s = "0", e = "0", s_width = 2, e_width = 2) {
  if (length(s) != length(e)) {
    warning("pad() called with wrong argument sizes")
    return(rep("", max(length(s), length(e))))
  }

  s <- as.numeric(s)
  e <- as.numeric(e)

  s_fmt <- paste0("%0", s_width, "d")
  e_fmt <- paste0("%0", e_width, "d")

  s <- sprintf(s_fmt, s)
  e <- sprintf(e_fmt, e)

  paste0("s", s, "e", e)
}

#' Assemble a trakt.tv API URL
#'
#' `build_trakt_url` assembles a trakt.tv API URL from different arguments.
#' The result should be fine for use with [trakt_get], since that's what this
#' function was created for.
#' @param ... Unnamed arguments will be concatenated with `/` as separators to
#' form the path of the API URL, e.g. the arguments `movies`,
#' `tron-legacy-2012` and `releases` will be concatenated to
#' `movies/tron-legacy-2012/releases`. Additional **named** arguments will be
#' used as query parameters, usually `extended = "full"` or others.
#' @param validate `logical(1) [TRUE]`: Whether to check the URL via
#'   `httr::HEAD` request.
#' @return A URL: `character` of length 1. If `validate = TRUE`, also a message
#'   including the HTTP status code return by a `HEAD` request.
#' @family utility functions
#' @importFrom httr stop_for_status modify_url
#' @export
#' @note Please be aware that the result of this function is not verified to be
#' a working trakt.tv API URL unless `validate = TRUE`, in which case a `HEAD`
#' request is performed that does not actually receive any data, but from its
#' returned status code the validity of the URL can be inferred.
#' @examples
#' build_trakt_url("shows", "breaking-bad", extended = "full")
#' build_trakt_url("shows", "popular", page = 3, limit = 5)
#'
#' # Path can also be partially assembled already
#' build_trakt_url("users/jemus42", "ratings")
#'
#' # Validate a URL works
#' build_trakt_url("shows", "popular", page = 1, limit = 5, validate = TRUE)
build_trakt_url <- function(..., validate = FALSE) {
  dots <- list(...)

  # Nuke NULL elements
  dots <- dots[purrr::map_lgl(dots, ~ !is.null(.x))]

  # If there are no named elements, names() will return NULL
  if (!is.null(names(dots))) {
    path <- paste0(dots[names(dots) == ""], collapse = "/")
    queries <- dots[names(dots) != ""]
  } else {
    path <- paste0(dots, collapse = "/")
    queries <- NULL
  }

  url <- modify_url(url = "https://api.trakt.tv", path = path, query = queries)

  # Validate
  if (validate) {
    response <- trakt_get(url, HEAD = TRUE)
    if (!identical(response$status, 200L)) {
      stop_for_status(response$status)
    }
  }

  url
}

# API docs helpers -----

#' Get API docs keys
#'
#' @param section E.g. "movies"
#' @param method  E.g "summary"
#' @param key  E.g. "url", "endpoint"
#'
#' @return `character(1)`
#' @keywords internal
#' @importFrom purrr pluck
apidoc <- function(section, method, key = NULL) {

  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("Please install the 'yaml' package")
  }

  system.file("api-methods.yml", package = "tRakt") %>%
    yaml::read_yaml() %>%
    pluck(section, method, key)
}

#' Get a formatted API url for an endpoint
#'
#' @param section E.g. "movies"
#' @param method  E.g. "summary"
#'
#' @return Markdown-formatted url
#' @keywords internal
apiurl <- function(section, method, prefix = "@source ") {
  if (!requireNamespace("glue", quietly = TRUE)) {
    stop("Please install the 'glue' package")
  }

  func <- apidoc(section, method, "implementation")
  endpoint <- apidoc(section, method, "endpoint")
  url <- apidoc(section, method, "url")
  authenticated <- isTRUE(apidoc(section, method, "authentication"))
  authenticated <- ifelse(authenticated, " (Authentication required)", "")

  glue::glue('{prefix} {func} wraps endpoint [{endpoint}]({url}) {authenticated}')
}

