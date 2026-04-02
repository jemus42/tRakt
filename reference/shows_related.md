# Get similiar(ish) shows

Get similiar(ish) shows

## Usage

``` r
shows_related(id, limit = 10L, extended = "min")
```

## Source

`shows_related()` wraps endpoint
[/shows/:id/related](https://trakt.docs.apiary.io/#reference/shows/related/get-related-shows).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

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

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## See also

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
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md)

## Examples

``` r
shows_related("breaking-bad", limit = 5)
#> # A tibble: 5 × 35
#>   related_to    year title    votes genres rating status country network runtime
#>   <chr>        <int> <chr>    <int> <list>  <dbl> <chr>  <chr>   <chr>     <int>
#> 1 breaking-bad  2015 Better … 34065 <chr>    8.80 ended  us      AMC          50
#> 2 breaking-bad  2002 The Wire 18185 <chr>    9.19 ended  us      HBO          60
#> 3 breaking-bad  1999 The Sop… 19034 <chr>    9.11 ended  us      HBO          55
#> 4 breaking-bad  2017 Ozark    18343 <chr>    8.26 ended  us      Netflix      60
#> 5 breaking-bad  2015 Narcos   18828 <chr>    8.48 ended  us      Netflix      50
#> # ℹ 25 more variables: tagline <chr>, trailer <chr>, homepage <chr>,
#> #   language <chr>, overview <chr>, languages <list>, subgenres <list>,
#> #   updated_at <dttm>, first_aired <dttm>, certification <chr>,
#> #   comment_count <int>, total_runtime <int>, aired_episodes <int>,
#> #   original_title <chr>, available_translations <list>, airs_day <chr>,
#> #   airs_time <chr>, airs_timezone <chr>, imdb <chr>, slug <chr>, tmdb <chr>,
#> #   tvdb <chr>, trakt <chr>, plex_guid <chr>, plex_slug <chr>
```
