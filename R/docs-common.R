#' Common API parameters
#'
#' These parameters are used *a lot* throughout this package, and they tend to be
#' alsways the same. Here there are all documented in one place, which is intended
#' to make the individual function documentation more consistent.
#'
#' @name trakt_api_common_parameters
#' @param target `character(1)`: The ID of the item requested. Preferably the
#' `Trakt ID` (e.g. `1390`), `slug` (e.g. `"game-of-thrones"`), or `IMDb ID` (e.g. `"tt0944947"`).
#' Can also be of length greater than 1, in which case the function is called on all
#' `target` values separately and the result is combined.
#' @param extended `character(1)`: Either `"min"` (API default) or `"full"`. The latter
#' returns more variables and should generally only be used if required.
#' @param type `character(1)`: Either `"shows"` or `"movies"`. For season/episode-specific
#' functions, values `seasons` or `episodes` are also allowed.
#' @param user Target username. Defaults to `getOption("trakt.username")`.
#' Can also be of length greater than 1, in which case the function is called on all
#' `user` values separately and the result is combined.
#' @param period `character(1) ["weekly"]`: Which period to filter by. Possible values
#' are `"weekly"`, `"monthly"`, `"yearly"`, `"all"`.
#' @param limit `integer(1) [10L]`: Number of items to return. Must be greater
#' than `0` and will be coerced to `integer`.
#' @param season,episode `integer(1) [1L]`: The season and eisode number. If longer,
#' e.g. `1:5`, the function is vectorized and the output will be
#' combined. This may result in *a lot* of API calls. Use wisely.
#'
#' @section Item identifiers:
#'
#' The `target` parameter is usually used to identify shows, movies or people.
#' In each of these cases, the value of the parameter must be a valid ID of one of the
#' following kinds:
#'
#' - **Trakt ID**: A numeric ID used by trakt.tv, which is included as a variable
#' named `trakt` by every function for the output item. These IDs are unique for their
#' respective category (or `type`, e.g. shows, movies, people) and can be expected to
#' have full coverage, meaning that every item will have a Trakt ID.
#' - **Slug**: A human-readable identifier used on the trakt.tv site, e.g. `game-of-thrones`.
#' While these are easy to remember, they have the risk of clashing with numeric IDs.
#' One example is the show "24", which has the slug `24`. However, the show "Presidio Med"
#' has the **Trakt ID** `24`, so if you supply `target = 24` the API assumes you meant the
#' Trakt ID instead of the slug. This is bad. Use `Trakt ID`s whenever possible.
#' - **IMDb ID**: Relatively self-explanatory. You can retrieve them easily via most
#' functions or by searching on [IMDb.com](https://www.imdb.com/). Since IMDb is an
#' external service, these IDs should be used for linking with other data source rather
#' than as search parameters for the trakt API, as it can not be guaranteed that
#' every item on trakt.tv does have an IMDb ID.
#'
#' The API does return some other IDs, notably for [the tvdb](https://www.thetvdb.com).
#' These are useful for linking with other data sources like [fanart.tv](https://fanart.tv/).
#' They are not used as search parameters for the trakt API.
#'
#' @section Extended Information:
#' The `extended` parameter controls the amount of information (i.e. the number of variables)
#' included in the output.
#'
#' - `"min"`: The default option returns minimal information. For shows, movies, episodes
#' and people, the result will only include a title or name, possibly a year, and the
#' standard set of IDs (see section above). This is the fastest option as it requires
#' less content to be sent from the API and less post-processing work to produce tabular
#' output.
#' - `"full"`: The maximum amount of information. This option is required if you are
#' interested in the `votes` and `rating` variables, as well as additional metadata
#' like air dates, plot summaries, and a plethora of other variables depending on the `type`.
#' If you intend on retrieving data for a large number of items, e.g. via [trakt.popular],
#' it is highly recommend to cache the output locally when using `extended = "full"` and
#' subsequently only use `extended = "min"`. Then you can merge or [full_join()][dplyr::full_join]
#' the minimal data with your cached data.
NULL
