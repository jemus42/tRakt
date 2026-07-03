# Recently updated media

Return movies or shows that were updated on trakt.tv since `start_date`.
Handy for keeping a local cache in sync: store the most recent
`updated_at` you have seen and poll for anything newer.

## Usage

``` r
movies_updates(limit = 10, extended = "min", start_date = Sys.Date() - 1)

shows_updates(limit = 10, extended = "min", start_date = Sys.Date() - 1)
```

## Source

`movies_updates()` wraps endpoint
[/movies/updates/:start_date](https://trakt.docs.apiary.io/#reference/movies/updates/get-recently-updated-movies).

`shows_updates()` wraps endpoint
[/shows/updates/:start_date](https://trakt.docs.apiary.io/#reference/shows/updates/get-recently-updated-shows).

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

- start_date:

  `Date | character(1)`: Return items updated since this date. Defaults
  to yesterday. The trakt.tv API only accepts dates up to **30 days** in
  the past; older dates return no results (a warning is emitted).

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## Note

Unlike the other dynamic lists, the updates endpoints do not support the
`filters` argument.

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
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other dynamic lists:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`filters`](https://jemus42.github.io/tRakt/reference/filters.md),
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other show data:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md),
[`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md)

## Examples

``` r
movies_updates()
#> # A tibble: 10 × 7
#>    updated_at          title                      year  trakt slug  imdb    tmdb
#>    <dttm>              <chr>                     <int>  <int> <chr> <chr>  <int>
#>  1 2026-07-02 09:18:29 The Warminster Thing         NA 1.38e6 the-… tt71… 1.72e6
#>  2 2026-07-02 11:33:36 The Matrix Reloaded        2003 4.82e2 the-… tt02… 6.04e2
#>  3 2026-07-02 11:44:31 Weapons                    2025 8.67e5 weap… tt26… 1.08e6
#>  4 2026-07-02 11:44:36 The Devil Wears Prada 2    2026 1.07e6 the-… tt33… 1.31e6
#>  5 2026-07-02 12:32:11 Obsession                  2026 1.10e6 obse… tt37… 1.34e6
#>  6 2026-07-02 12:32:11 Spider-Man: Brand New Day  2026 9.05e5 spid… tt22… 9.70e5
#>  7 2026-07-02 12:32:12 The Dark Knight            2008 1.2 e2 the-… tt04… 1.55e2
#>  8 2026-07-02 12:32:15 Static                     2012 1.06e5 stat… tt18… 1.66e5
#>  9 2026-07-02 12:32:57 Mantra Muugdha             2026 1.31e6 mant… tt37… 1.58e6
#> 10 2026-07-02 12:33:03 Chimera                    2026 1.38e6 chim… tt33… 1.72e6
shows_updates(start_date = Sys.Date() - 7)
#> # A tibble: 10 × 8
#>    updated_at          title                  year trakt slug  tvdb  imdb  tmdb 
#>    <dttm>              <chr>                 <int> <chr> <chr> <chr> <chr> <chr>
#>  1 2026-06-26 02:33:36 The Golden Horde       2018 1692… the-… 3447… tt96… 78302
#>  2 2026-06-26 02:34:02 Coachella              2010 78989 coac… 2482… NA    NA   
#>  3 2026-06-26 02:35:26 Everything Now Show    2018 2840… ever… NA    tt25… 2901…
#>  4 2026-06-26 02:38:00 Shopping Queen (DE)    2012 1579… shop… 2665… tt22… 93768
#>  5 2026-06-26 02:45:34 Jornal Nacional        1969 2131… jorn… 3397… tt04… 16807
#>  6 2026-06-26 06:12:52 Beach Boys             1997 23868 beac… 1172… tt02… 23974
#>  7 2026-06-26 06:14:02 El-Hazard: The Wande…  1995 63735 el-h… 79241 tt01… 22098
#>  8 2026-06-26 06:15:53 Franny's Feet          2003 9921  fran… 1289… tt03… 9970 
#>  9 2026-06-26 06:15:56 First Australians      2008 21018 firs… 83409 tt13… 21114
#> 10 2026-06-26 06:16:38 At Last the 1948 Show  1967 188   at-l… 70956 tt00… 189  
```
