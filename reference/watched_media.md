# Most watched media

These functions return the most watched movies/shows on trakt.tv.

## Usage

``` r
movies_watched(
  limit = 10,
  extended = c("min", "full"),
  period = c("weekly", "monthly", "yearly", "all"),
  query = NULL,
  years = NULL,
  genres = NULL,
  languages = NULL,
  countries = NULL,
  runtimes = NULL,
  ratings = NULL,
  certifications = NULL
)

shows_watched(
  limit = 10,
  extended = c("min", "full"),
  period = c("weekly", "monthly", "yearly", "all"),
  query = NULL,
  years = NULL,
  genres = NULL,
  languages = NULL,
  countries = NULL,
  runtimes = NULL,
  ratings = NULL,
  certifications = NULL,
  networks = NULL,
  status = NULL
)
```

## Source

`movies_watched()` wraps endpoint
[/movies/watched/:period](https://trakt.docs.apiary.io/#reference/movies/watched/get-the-most-watched-movies).

`shows_watched()` wraps endpoint
[/shows/watched/:period](https://trakt.docs.apiary.io/#reference/shows/watched/get-the-most-watched-shows).

## Arguments

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

- extended:

  `character(1)`: Either `"min"` (API default) or `"full"`. The latter
  returns more variables and should generally only be used if required.
  See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- period:

  `character(1) ["weekly"]`: Which period to filter by. Possible values
  are `"weekly"`, `"monthly"`, `"yearly"`, `"all"`.

- query:

  `character(1)`: Search string for titles and descriptions. For
  [`search_query()`](https://jemus42.github.io/tRakt/reference/search_query.md)
  other fields are searched depending on the `type` of media. See [the
  API docs](https://trakt.docs.apiary.io/#reference/search/text-query)
  for a full reference.

- years:

  `character | integer`: 4-digit year (`2010`) **or** range, e.g.
  `"2010-2020"`. Can also be an integer vector of length two which will
  be coerced appropriately, e.g. `c(2010, 2020)`.

- genres:

  `character(n)`: Genre slug(s). See
  [`trakt_genres`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for a table of genres. Multiple values are allowed and will be
  concatenated.

- languages:

  `character(n)`: Two-letter language code(s). Also see
  [`trakt_languages`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for available languages (code and name).

- countries:

  `character(n)`: Two-letter country code(s). See
  [`trakt_countries`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md).

- runtimes:

  `character | integer`: Integer range in minutes, e.g. `30-90`. Can
  also be an integer vector of length two which will be coerced
  appropriately.

- ratings:

  `character | integer`: Integer range between `0` and `100`. Can also
  be an integer vector of length two which will be coerced
  appropriately. Note that user-supplied ratings are in the range of 1
  to 10, yet the ratings on the site itself are scaled to the range of 1
  to 100.

- certifications:

  `character(n)`: Certification(s) like `pg-13`. Multiple values are
  allowed. Use
  [`trakt_certifications`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for reference. Note that there are different certifications for shows
  and movies.

- networks:

  `character(n)`: (Shows only) Network name like `HBO`. See
  [`trakt_networks`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for a list of known networks.

- status:

  `character(n)`: (Shows only) The status of the shows. One of
  `"returning series"`, `"in production"`, `"planned"`, `"canceled"`, or
  `"ended"`.

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## The Dynamic Lists on trakt.tv

These functions access the automatically updated lists provided by
trakt.tv. Each function comes in two flavors: Shows or movies. The
following descriptions are adapted directly from the [API
reference](https://trakt.docs.apiary.io/#reference/movies/popular/get-popular-movies).

- [Popular](https://jemus42.github.io/tRakt/reference/popular_media.md):
  Popularity is calculated using the rating percentage and the number of
  ratings.

- [Trending](https://jemus42.github.io/tRakt/reference/trending_media.md):
  Returns all movies/shows being watched right now. Movies/shows with
  the most users are returned first.

- [Played](https://jemus42.github.io/tRakt/reference/played_media.md):
  Returns the most played (a single user can watch multiple times)
  movies/shows in the specified time `period`.

- Watched: Returns the most watched (unique users) movies/shows in the
  specified time `period`.

- [Collected](https://jemus42.github.io/tRakt/reference/collected_media.md):
  Returns the most collected (unique users) movies/shows in the
  specified time `period`.

- [Anticipated](https://jemus42.github.io/tRakt/reference/anticipated_media.md):
  Returns the most anticipated movies/shows based on the number of lists
  a movie/show appears on. The functions for **Played**, **Watched**,
  **Collected** and **Played** each return the same additional variables
  besides the media information: `watcher_count`, `play_count`,
  `collected_count`, `collector_count`.

## See also

Other movie data:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`movies_boxoffice()`](https://jemus42.github.io/tRakt/reference/movies_boxoffice.md),
[`movies_related()`](https://jemus42.github.io/tRakt/reference/movies_related.md),
[`movies_releases()`](https://jemus42.github.io/tRakt/reference/movies_releases.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md)

Other dynamic lists:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md)

Other shows data:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md)

Other dynamic lists:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md)
