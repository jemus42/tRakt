#' Easy episode id padding
#'
#' Simple function to ease the creation of `sXXeYY` episode ids.
#' Note that `s` and `e` ust have the same length.
#' @param s Input season number, coerced to `character`.
#' @param e Input episode number, coerced to `character`.
#' @param s_width The length of the season number padding. Defaults to 2.
#' @param e_width The length of the episode number padding. Defaults to 2.
#' @return A `character` in the common `sXXeYY` format
#' @family utility functions
#' @export
#' @note I like my sXXeYY format, okay?
#' @examples
#' pad(2, 4) # Returns "s02e04"
pad <- function(s = "0", e = "0", s_width = 2, e_width = 2) {
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

#' Get info from a show URL
#'
#' `parse_trakt_url` extracts some info from a show URL
#' @param url Input URL. must be a `character`, but not a valid URL.
#' @param epid Whether the episode ID (`sXXeYY` format) should be extracted.
#' Defaults to `FALSE`.
#' @param getslug Whether the `slug` should be extracted. Defaults to `FALSE`.
#' @return A `list` containing at least the show name.
#' @family utility functions
#' @export
#' @importFrom stringr str_split
#' @note This is pointless.
#' @examples
#' parse_trakt_url("http://trakt.tv/show/fargo/season/1/episode/2", TRUE, TRUE)
#' parse_trakt_url("http://trakt.tv/show/breaking-bad", TRUE, FALSE)
parse_trakt_url <- function(url, epid = FALSE, getslug = FALSE) {
  showname <- stringr::str_split(url, "/")[[1]][5]
  ret <- list("show" = showname)
  if (epid) {
    season <- stringr::str_split(url, "/")[[1]][7]
    episode <- stringr::str_split(url, "/")[[1]][9]
    if (is.na(season) | is.na(episode)) {
      ret$epid <- NA
    } else {
      epid <- pad(season, episode)
      ret$epid <- epid
    }
  }
  if (getslug) {
    slug <- stringr::str_split(url, "/", 5)
    ret$slug <- slug[[1]][5]
  }
  ret
}

#' Quick datetime conversion
#'
#' Searches for datetime variables and converts them to `POSIXct` via \pkg{lubridate}.
#' @param response The input object. Must be `data.frame`(ish) or named `list`.
#' @return The same object with converted datetimes
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr mutate_at
#' @importFrom purrr map_at
#' @keywords internal
convert_datetime <- function(response) {
  if (!inherits(response, c("data.frame", "list"))) {
    stop("Object type not supported, must inherit from data.frame or list")
  }
  datevars <- c(
    "first_aired", "updated_at", "listed_at", "last_watched_at", "last_updated_at",
    "last_collected_at", "rated_at", "friends_at", "followed_at", "collected_at",
    "joined_at"
  )

  datevars <- datevars[datevars %in% names(response)]

  if (inherits(response, "data.frame")) {
    response %>%
      dplyr::mutate_at(.vars = dplyr::vars(datevars), lubridate::ymd_hms)
  } else {
    purrr::map_at(response, datevars, lubridate::ymd_hms)
  }
}

#' Assemble a trakt.tv API URL
#'
#' `build_trakt_url` assembles a trakt.tv API URL from different arguments.
#' The result should be fine for use with [trakt.api.call], since that's what this
#' function was created for.
#' @param section The section of the API methods, like `shows` or `movies`.
#' @param target1,target2,target3,target4,target5,target6 The target object, usually
#' a show or movie `slug` or something like `trending` and `popular`.
#' Will be concatenated after `section` to produce
#' a URL fragment like `movies/tron-legacy-2012/releases`.
#' @param validate `logical(1) [TRUE]`: Whether to check the URl via `httr::HEAD` request.
#' @param ... Other params used as `queries`. Must be named arguments
#' like `name = value`, commoly used is `extended = "min"`.
#' @return A `character` of length 1. If `validate = TRUE`, also a message including
#' the HTTP status code return by a `HEAD` request.
#' @family utility functions
#' @export
#' @note Please be aware that the result of this function is not verified to be a working trakt.tv
#' API URL, unless `validate = TRUE`, in which case a `HEAD` request is performed that
#' does not actually receive any data, but from its returned status code the validity
#' of the URL can be inferred.
#' @examples
#' build_trakt_url("shows", "breaking-bad", extended = "full")
#' build_trakt_url("shows", "popular", page = 3, limit = 5)
#'
#' # Validate a URL works
#' build_trakt_url("shows", "popular", page = 3, limit = 5, validate = TRUE)
build_trakt_url <- function(section, target1 = NULL, target2 = NULL, target3 = NULL,
                            target4 = NULL, target5 = NULL, target6 = NULL,
                            validate = FALSE, ...) {

  path <- paste0(c(section, target1, target2, target3, target4, target5, target6),
                 collapse = "/")

  url <- modify_url("https://api.trakt.tv",
                    path = path,
                    query = list(...))

  # Validate
  if (validate) {
    if (is.null(getOption("trakt.client.id"))) {
      options(trakt.client.id = "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2")
    }
    client.id <- getOption("trakt.client.id")

    # Headers and metadata
    agent <- httr::user_agent("https://github.com/jemus42/tRakt")

    headers <- httr::add_headers(.headers = c(
      "trakt-api-key" = client.id,
      "Content-Type" = "application/json",
      "trakt-api-version" = 2
    ))

    res <- httr::HEAD(url, agent, headers)
    status <- httr::status_code(res)
    if (!identical(status, 200L)) {
      stop("The URL returns a HTTP status '", status, "'")
    } else {
      message("The URL returns a HTTP status '", status, "'")
    }
  }

  url
}


#' Check username
#'
#' @param user The username input.
#' @param validate `logical(1) [TRUE]`: Retrieve user profile to check if it exists.
#' @return An error if the checks fail or else `TRUE` invisibly. If `validate`, the
#' user profile is returned as a `list`.
#' @keywords internal
check_username <- function(user, validate = FALSE) {
  fail_option <- is.null(getOption("trakt.username"))
  fail_empty_chr <- user == ""
  fail_null <- is.null(user)
  fail_chr <- !is.character(user)
  fail_na <- is.na(user)

  failed <- any(fail_option, fail_empty_chr, fail_null, fail_chr, fail_na)

  if (failed) {
    stop("Supplied user must be a character string, you provided <", user, ">")
  } else if (validate) {
    url <- build_trakt_url("users", user)
    invisible(trakt.api.call(url))
  } else {
    invisible(TRUE)
  }
}
