# Get similiar(ish) movies

Get similiar(ish) movies

## Usage

``` r
movies_related(id, limit = 10L, extended = "min")
```

## Source

`movies_related()` wraps endpoint
[/movies/:id/related](https://trakt.docs.apiary.io/#reference/movies/related/get-related-movies).

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
[`movies_releases()`](https://jemus42.github.io/tRakt/reference/movies_releases.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

## Examples

``` r
movies_related("the-avengers-2012", limit = 5)
#> # A tibble: 5 × 9
#>   related_to         year title      imdb  slug  tmdb  trakt plex_guid plex_slug
#>   <chr>             <int> <chr>      <chr> <chr> <chr> <chr> <chr>     <chr>    
#> 1 the-avengers-2012  2013 Iron Man 3 tt13… iron… 68721 50134 5fc695b6… iron-man…
#> 2 the-avengers-2012  2014 Captain A… tt18… capt… 1004… 72297 5d776908… captain-…
#> 3 the-avengers-2012  2011 Thor       tt08… thor… 10195 5408  5d776834… thor     
#> 4 the-avengers-2012  2016 Captain A… tt34… capt… 2711… 1691… 5d776adc… captain-…
#> 5 the-avengers-2012  2018 Black Pan… tt18… blac… 2840… 1813… 5d776b05… black-pa…
```
