# Get similiar(ish) shows

Get similiar(ish) shows

## Usage

``` r
shows_related(id, limit = 10L, extended = c("min", "full"))
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

  `character(1)`: Either `"min"` (API default) or `"full"`. The latter
  returns more variables and should generally only be used if required.
  See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

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
#> # A tibble: 5 × 8
#>   related_to   title             year trakt  slug             tvdb   imdb  tmdb 
#>   <chr>        <chr>            <int> <chr>  <chr>            <chr>  <chr> <chr>
#> 1 breaking-bad Better Call Saul  2015 59660  better-call-saul 273181 tt30… 60059
#> 2 breaking-bad The Wire          2002 1429   the-wire         79126  tt03… 1438 
#> 3 breaking-bad The Sopranos      1999 1389   the-sopranos     75299  tt01… 1398 
#> 4 breaking-bad Ozark             2017 119913 ozark            329089 tt50… 69740
#> 5 breaking-bad Narcos            2015 94630  narcos           282670 tt27… 63351
```
