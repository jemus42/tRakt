#' Cached filter datasets
#'
#' These datasets are used internally to check the optional
#' [filter parameters](https://trakt.docs.apiary.io/#introduction/filters) for certain
#' functions (see [search_query] or the dynamic lists like [shows_popular]).
#' They are unlikely to change often and are therefore included as package datasets.
#'
#' The datasets are prefixed with `trakt_` purely to avoid confusion or masking for
#' filter arguments of the same name.
#' @name trakt_datasets
#'
#' @format Every dataset is a [tibble()][tibble::tibble-package].
#' The following list includes the dataset topic with a link to the API documentation,
#' a short description and a list of variables with example values:
#'
#' - [Genres](https://trakt.docs.apiary.io/#reference/genres/list/get-genres):
#'  Genres for shows and movies (with their two-letter codes) trakt.tv knows.
#'   - Variables: `name` ("Action"), `slug` ("action"), `type` ("movies")
#' - [Languages](https://trakt.docs.apiary.io/#reference/languages/list):
#' Languages (and two-letter codes) trakt.tv knows.
#'   - Variables: `name` ("Arabic"), `code` ("ar"), `type` ("movies")
#' - [Networks](https://trakt.docs.apiary.io/#reference/networks/list):
#' TV networks trakt.tv knows.
#'   - Variables: `name` ("TBS"), `name_clean` ("tbs") (lower-case, no trailing whitespaces)
#' - [Countries](https://trakt.docs.apiary.io/#reference/countries/list):
#' Country names (and two-letter codes).
#'   - Variables: `name` ("Belarus"), `code` ("by"), `type` ("movies")
#' - [Certifications](https://trakt.docs.apiary.io/#reference/certifications/list):
#' TV and movie certifications (e.g. "PG-13" and the likes).
#'   - Variables: `country` ("us" only), `name` ("TV-PG"),
#'  `slug` ("tv-pg"), `description` ("Parental Guidance Suggested"), `type` ("shows")
#' @note Currently only US certifications are available.
NULL

#' @name trakt_datasets
#' @examples
#' head(trakt_genres)
"trakt_genres"

#' @name trakt_datasets
#' @examples
#' head(trakt_languages)
"trakt_languages"

#' @name trakt_datasets
#' @examples
#' head(trakt_networks)
"trakt_networks"

#' @name trakt_datasets
#' @examples
#' head(trakt_countries)
"trakt_countries"

#' @name trakt_datasets
#' @examples
#' trakt_certifications
"trakt_certifications"
