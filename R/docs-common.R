#' Common API parameters
#'
#' These parameters are used *a lot* throughout this package, and they tend to be
#' alsways the same. Here there are all documented in one place, which is intended
#' to make the individual function documentation more consistent.
#' As a side-effect, this is also visible to the user, which I believe to be acceptable.
#' @name trakt_api_common_parameters
#' @param target `character(1)`: The `id` of the item requested. Either the `slug`
#' (e.g. `"game-of-thrones"` for a show, or `"bryan-cranston"` for a person),
#' `Trakt ID` (e.g. `1390`) or `IMDB ID` (e.g. `"tt0944947"` or `"nm0186505"`).
#' Can also be of length greater than 1, in which case the function is called on all
#' `target` values separately and combined using [purrr::map_df] if possible.
#' @param extended `character(1)`: Either `"min"` (API default) or `"full"`. The latter
#' returns more variables and should generally only be used if required.
#' @param type `character(1)`: Either `"shows"` or `"movies"`.
#' @param user Target user. Defaults to `getOption("trakt.username")`.
#' Can also be of length greater than 1, in which case the function is called on all
#' `user` values separately and combined using [purrr::map_df].
#' @param period `character(1) ["weekly"]`: Which period to filter by. Possible values
#' are `"weekly"`, `"monthly"`, `"yearly"`, `"all"`.
NULL
