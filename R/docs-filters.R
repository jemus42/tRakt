#' Result Filters
#'
#' You can specifiy additional search filters in some functions. These filters are
#' documented [in the official API reference](https://trakt.docs.apiary.io/#introduction/filters).
#' For convenience, all supported filters are implemented as explicit, named arguments.
#' @name search_filters
#'
#' @param query `character(1)`: Search titles and descriptions.
#' @param years `integer(1)`: 4-digit year **or** range, e.g. `2010-2020`. Can also be an integer
#' vector of length two which will be coerced appropriately.
#' @param genres `character(n)`: Genre  slug(s). See [`genres`] for a table of genres.
#' Multiple values are allowed and will be concatenated.
#' @param languages `character(n)`: Two-digit language code(s). Also see [`languages`] for
#' table of available languages.
#' @param countries `character(n)`: Two-character country code(s). See [`countries`].
#' @param runtimes `character | integer`: Integer range in minutes, e.g. `30-90`. Can also be an integer
#' vector of length two which will be coerced appropriately.
#' @param ratings `character | integer`:  Integer range between `0` and `100`. Can also be an integer
#' vector of length two which will be coerced appropriately.
#' @param certifications `character(n)`: Certification(s) like `pg-13`.
#' Multiple values are allowed. Use [`certifications`] for reference. Note that there
#' are different certifications for shows and movies.
#' @param networks `character(n)`: (Shows only) Network name like `HBO`. See [`networks`]
#' for a list of known networks.
#' @param status `character(n)`: (Shows only) The status of the shows. One of `returning series`,
#' `in production`, `planned`, `canceled`, or `ended`
#'
#' @seealso [automated_lists]
NULL
