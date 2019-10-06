#' Result Filters
#'
#' You can specifiy additional search filters in some functions. These filters are
#' documented [in the API reference](https://trakt.docs.apiary.io/#introduction/filters).
#' For convenience, all supported filters are implemented as explicit, named arguments.
#' @name search_filters
#'
#' @param query `character(1)`: Search string for titles and descriptions.
#'   For `search_query()` other fields are searched depending on the `type` of media.
#'   See [the API docs](https://trakt.docs.apiary.io/#reference/search/text-query) for a
#'   full reference.
#' @param years `character | integer`: 4-digit year (`2010`) **or** range,
#'   e.g. `"2010-2020"`. Can also be an integer vector of length two which will be
#'   coerced appropriately.
#' @param genres `character(n)`: Genre  slug(s).
#'   See [`trakt_genres`] for a table of genres.
#'   Multiple values are allowed and will be concatenated.
#' @param languages `character(n)`: Two-digit language code(s).
#'   Also see [`trakt_languages`] for table of available languages.
#' @param countries `character(n)`: Two-character country code(s).
#'   See [`trakt_countries`].
#' @param runtimes `character | integer`: Integer range in minutes, e.g. `30-90`.
#'   Can also be an integer vector of length two which will be coerced appropriately.
#' @param ratings `character | integer`:  Integer range between `0` and `100`.
#'   Can also be an integer vector of length two which will be coerced appropriately.
#' @param certifications `character(n)`: Certification(s) like `pg-13`.
#'   Multiple values are allowed. Use [`trakt_certifications`] for reference.
#'   Note that there are different certifications for shows and movies.
#' @param networks `character(n)`: (Shows only) Network name like `HBO`.
#'   See [`trakt_networks`] for a list of known networks.
#' @param status `character(n)`: (Shows only) The status of the shows.
#'   One of `"returning series"`, `"in production"`, `"planned"`,
#'   `"canceled"`, or `"ended"`.
#'
#' @seealso [dynamic_lists], where these parameters are used
NULL
