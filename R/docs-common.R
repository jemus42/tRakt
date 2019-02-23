#' Movie or show ID
#' @name id_movie_show
#' @param target `character(1)`: The `id` of the item requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `Trakt ID` (e.g. `1390`) or `IMDB ID` (e.g. `"tt0944947"`).
#' Can also be of length greater than 1, in which case the function is called on all
#' `target` values separately and combined using [purrr::map_df].
NULL

#' A person
#' @name id_person
#' @param target `character(1)`: The `id` of the person requested. Either the `slug`
#' (e.g. `"bryan-cranston"`), `Trakt ID` (e.g. `297737`) or `IMDB ID` (e.g. `"nm0186505"`).
NULL

#' Extended information
#' @name extended_info
#' @param extended `character(1)`: Either `"min"` (API default) or `"full"`. The latter
#' returns more variables and should generally only be used if required.
NULL

#' Type: Shows or Movies
#' @name type_shows_movies
#' @param type `character(1)`: Either `"shows"` or `"movies"`.
#' @keywords internal
NULL

#' A user
#' @name user_param
#' @param user Target user. Defaults to `getOption("trakt.username")`.
#' Can also be of length greater than 1, in which case the function is called on all
#' `user` values separately and combined using [purrr::map_df].
NULL

#' Return a tibble without further info
#' @name return_tibble
#' @return A [tibble][tibble::tibble-package].
#' @keywords internal
NULL
