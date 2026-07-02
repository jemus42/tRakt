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
#> # A tibble: 5 × 11
#>   related_to   year title aired_episodes imdb  slug  tmdb  tvdb  trakt plex_guid
#>   <chr>       <int> <chr>          <int> <chr> <chr> <chr> <chr> <chr> <chr>    
#> 1 breaking-b…  2015 Mr. …             45 tt41… mr-r… 62560 2895… 93720 5d9c0867…
#> 2 breaking-b…  2015 Bett…             63 tt30… bett… 60059 2731… 59660 5d9c0825…
#> 3 breaking-b…  2013 Peak…             36 tt24… peak… 60574 2709… 60158 5d9c0835…
#> 4 breaking-b…  2014 Fargo             51 tt28… fargo 60622 2696… 60203 5d9c0838…
#> 5 breaking-b…  2015 Narc…             30 tt27… narc… 63351 2826… 94630 5d9c0803…
#> # ℹ 1 more variable: plex_slug <chr>
```
