# Anticipated media

These functions return the most anticipated movies/shows on trakt.tv.

## Usage

``` r
movies_anticipated(
  limit = 10,
  extended = "min",
  filters = NULL,
  query = NULL,
  years = NULL,
  genres = NULL,
  languages = NULL,
  countries = NULL,
  runtimes = NULL,
  ratings = NULL,
  certifications = NULL
)

shows_anticipated(
  limit = 10,
  extended = "min",
  filters = NULL,
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

`movies_anticipated()` wraps endpoint
[/movies/anticipated](https://trakt.docs.apiary.io/#reference/movies/anticipated/get-the-most-anticipated-movies).

`shows_anticipated()` wraps endpoint
[/shows/anticipated](https://trakt.docs.apiary.io/#reference/shows/anticipated/get-the-most-anticipated-shows).

## Arguments

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

- extended:

  `character`: Level of detail for the API response.

  - `"min"` (default): Minimal info (title, year, IDs). Omits the
    `extended` query param.

  - `"full"`: Complete info including overview, ratings, runtime, etc.

  - `"images"`: Minimal info plus image URLs (returned as a
    list-column).

  - `"full,images"`: Complete info plus images.

  - `"metadata"`: Collection endpoints only; adds video/audio metadata.

  Multiple values can be combined as a comma-separated string (e.g.
  `"full,images"`) or a character vector (e.g. `c("full", "images")`).

- filters:

  A
  [`trakt_filters`](https://jemus42.github.io/tRakt/reference/filters.md)
  object created with
  [`filters_movies()`](https://jemus42.github.io/tRakt/reference/filters.md),
  [`filters_shows()`](https://jemus42.github.io/tRakt/reference/filters.md),
  or
  [`filters_episodes()`](https://jemus42.github.io/tRakt/reference/filters.md)
  that refines which items are returned. See
  [filters](https://jemus42.github.io/tRakt/reference/filters.md) for
  the full set of supported filters. Supplying filters as individual
  arguments (`genres`, `years`, `networks`, ...) is soft-deprecated in
  favour of this argument; if both are given, `filters` takes
  precedence.

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

- [Watched](https://jemus42.github.io/tRakt/reference/watched_media.md):
  Returns the most watched (unique users) movies/shows in the specified
  time `period`.

- [Collected](https://jemus42.github.io/tRakt/reference/collected_media.md):
  Returns the most collected (unique users) movies/shows in the
  specified time `period`.

- Anticipated: Returns the most anticipated movies/shows based on the
  number of lists a movie/show appears on. The functions for **Played**,
  **Watched**, **Collected** and **Played** each return the same
  additional variables besides the media information: `watcher_count`,
  `play_count`, `collected_count`, `collector_count`.

## See also

Other movie data:
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
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other dynamic lists:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`filters`](https://jemus42.github.io/tRakt/reference/filters.md),
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other shows data:
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

## Examples

``` r
# Get 15 the most anticipated upcoming shows on Netflix that air this year
current_year <- format(Sys.Date(), "%Y")
shows_anticipated(
  limit = 15,
  filters = filters_shows(networks = "Netflix", years = current_year)
)
#> # A tibble: 15 × 11
#>    list_count  year title aired_episodes imdb  slug  tmdb  tvdb  trakt plex_guid
#>         <int> <int> <chr>          <int> <chr> <chr> <chr> <chr> <chr> <chr>    
#>  1      10450  2026 HIS …              6 tt33… his-… 2597… 4525… 2494… 66a33f8e…
#>  2       9646  2026 I Wi…              8 tt34… i-wi… 2781… 4571… 2653… 6749125e…
#>  3       9329  2026 The …              8 tt27… the-… 2249… 4339… 2045… 64456c8c…
#>  4       6668  2026 Some…              8 tt32… some… 2592… 4522… 2487… 669816fb…
#>  5       5517  2026 Man …              7 tt27… man-… 2233… 4330… 2035… 6424274b…
#>  6       5352  2026 Lege…              6 tt33… lege… 2622… 4536… 2530… 670911d7…
#>  7       4598  2026 Big …              8 tt36… big-… 2915… 4668… 2857… 68a2c3a9…
#>  8       4108  2026 Dete…              9 tt31… dete… 2495… 4478… 2317… 65fbe43c…
#>  9       4005  2026 How …              8 tt31… how-… 2330… 4385… 2082… 64e5bf3d…
#> 10       4002  2026 Run …              8 tt91… run-… 2442… 4450… 2208… 65b0456b…
#> 11       3999  2026 Stra…             10 tt27… stra… 2242… 4629… 2042… 68093ee0…
#> 12       3982  2026 Agat…              3 tt31… agat… 2505… 4484… 2331… 66680ebb…
#> 13       3546  2026 Berl…              8 tt42… berl… 3080… 4776… 3107… 694c8321…
#> 14       3519  2026 Teac…             10 tt34… teac… 2761… 4643… 2626… 68667e7f…
#> 15       3299  2026 Neme…              8 tt36… neme… 2858… 4610… 2784… 67c993ea…
#> # ℹ 1 more variable: plex_slug <chr>
```
