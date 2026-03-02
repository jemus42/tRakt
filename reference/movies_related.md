# Get similiar(ish) movies

Get similiar(ish) movies

## Usage

``` r
movies_related(id, limit = 10L, extended = c("min", "full"))
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
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

## Examples

``` r
movies_related("the-avengers-2012", limit = 5)
#> # A tibble: 5 × 30
#>   related_to      year title  votes genres rating status country runtime tagline
#>   <chr>          <int> <chr>  <int> <list>  <dbl> <chr>  <chr>     <int> <chr>  
#> 1 the-avengers-…  2011 Capt…  47072 <chr>    7.40 relea… us          124 We are…
#> 2 the-avengers-…  2008 Iron…  62938 <chr>    8.08 relea… us          126 Heroes…
#> 3 the-avengers-…  2011 Thor   45218 <chr>    7.15 relea… us          115 Courag…
#> 4 the-avengers-…  2014 Guar… 108095 <chr>    8.26 relea… us          121 When t…
#> 5 the-avengers-…  2000 X-Men  26665 <chr>    7.47 relea… us          104 Trust …
#> # ℹ 20 more variables: trailer <chr>, homepage <chr>, language <chr>,
#> #   overview <chr>, released <date>, languages <list>, subgenres <list>,
#> #   updated_at <dttm>, after_credits <lgl>, certification <chr>,
#> #   comment_count <int>, during_credits <lgl>, original_title <chr>,
#> #   available_translations <list>, imdb <chr>, slug <chr>, tmdb <chr>,
#> #   trakt <chr>, plex_guid <chr>, plex_slug <chr>
```
