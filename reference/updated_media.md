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
#> # A tibble: 10 × 8
#>    updated_at           year title           imdb  plex$guid slug    tmdb  trakt
#>    <dttm>              <int> <chr>           <chr> <chr>     <chr>  <int>  <int>
#>  1 2026-09-01 08:05:20  2026 32 Frames: A 9… tt42… NA        32-f… 1.70e6 1.37e6
#>  2 2026-09-01 08:05:21  1966 Texas Across t… tt00… 5d776891… texa… 5.25e4 3.70e4
#>  3 2026-09-01 08:05:21  2026 Doutor Monstro  tt30… NA        dout… 1.23e6 9.93e5
#>  4 2026-09-01 08:05:21  2026 La Malédiction… tt27… NA        la-m… 1.45e6 1.18e6
#>  5 2026-09-01 08:05:21  2025 Flush           tt37… 6866b1d5… flus… 1.51e6 1.24e6
#>  6 2026-09-01 08:05:21  2026 Meeting Marsha  tt38… NA        meet… 1.58e6 1.31e6
#>  7 2026-09-01 08:05:21  2026 Kesong Puti     tt40… 69c45027… keso… 1.67e6 1.36e6
#>  8 2026-09-01 08:05:21  2026 Réngonghú       tt43… 6a6edf19… reng… 1.74e6 1.39e6
#>  9 2026-09-01 08:05:21  2026 Tysha           tt43… NA        tysh… 1.74e6 1.39e6
#> 10 2026-09-01 08:05:21  2026 The Rootman     tt44… NA        the-… 1.76e6 1.39e6
#> # ℹ 1 more variable: plex$slug <chr>
shows_updates(start_date = Sys.Date() - 7)
#> # A tibble: 10 × 11
#>    updated_at           year title  aired_episodes imdb  slug  tmdb  tvdb  trakt
#>    <dttm>              <int> <chr>           <int> <chr> <chr> <chr> <chr> <chr>
#>  1 2026-08-26 06:07:48  1978 Enemy…             26 tt01… enem… 12213 73036 12160
#>  2 2026-08-26 06:09:54  2010 Bert …             40 tt16… bert… 33052 1966… 32907
#>  3 2026-08-26 06:10:13  1966 Cool …             60 tt00… cool… 3642  78433 3619 
#>  4 2026-08-26 06:10:16  2012 Abyss…            162 tt21… abys… 42280 2880… 96162
#>  5 2026-08-26 06:11:00  1986 Alice…              4 tt04… alic… 52445 2909… 94986
#>  6 2026-08-26 06:11:01  1987 Echoe…              2 tt00… echo… 47234 NA    2349…
#>  7 2026-08-26 06:11:02    NA Diamo…              0 tt08… diam… 6568  NA    1910…
#>  8 2026-08-26 06:11:11  1991 The 1…             12 tt02… the-… 48455 82140 48162
#>  9 2026-08-26 06:11:12  2001 El Ma…             95 tt02… el-m… 16703 3203… 1333…
#> 10 2026-08-26 06:11:23  2010 Baske…            184 tt16… bask… 32789 1636… 32648
#> # ℹ 2 more variables: plex_guid <chr>, plex_slug <chr>
```
