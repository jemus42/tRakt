#' Extended information
#' @name extended_info
#' @param extended `character(1)`: Either `"min"` (API default) or `"full"`. The latter
#' returns more variables and should generally only be used if required.
NULL

#' Type: Shows or Movies
#' @name type_shows_movies
#' @param type `character(1)`: Either `"shows"` or `"movies"`.
NULL

#' User parameter
#' @name user_param
#' @param user Target user. Defaults to `getOption("trakt.username")`. If multiple users
#' are specified, the results will be combined with [rbind][rbind].
NULL

#' Return a tibble without further info
#' @name return_tibble
#' @return A [tibble][tibble::tibble-package].
NULL
