# Get who's watching a thing right now

Get who's watching a thing right now

## Usage

``` r
movies_watching(id, extended = "min")

shows_watching(id, extended = "min")

seasons_watching(id, season = 1L, extended = "min")

episodes_watching(id, season = 1L, episode = 1L, extended = "min")
```

## Source

`movies_watching()` wraps endpoint
[/movies/:id/watching](https://trakt.docs.apiary.io/#reference/movies/watching/get-users-watching-right-now).

`shows_watching()` wraps endpoint
[/shows/:id/watching](https://trakt.docs.apiary.io/#reference/shows/watching/get-users-watching-right-now).

`episodes_watching()` wraps endpoint
[/shows/:id/seasons/:season/episodes/:episode/watching](https://trakt.docs.apiary.io/#reference/episodes/watching/get-users-watching-right-now).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

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

- season, episode:

  `integer(1) [1L]`: The season and episode number. If longer, e.g.
  `1:5`, the function is vectorized and the output will be combined.
  This may result in *a lot* of API calls. Use wisely.

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## Functions

- `movies_watching()`: Who's watching a movie.

- `shows_watching()`: Who's watching a show.

- `seasons_watching()`: Who's watching a season.

- `episodes_watching()`: Who's watching an episode.

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

Other show data:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md),
[`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

## Examples

``` r
movies_watching("deadpool-2016")
#> # A tibble: 1 × 8
#>   username        private deleted user_name   vip   vip_ep director user_slug   
#>   <chr>           <lgl>   <lgl>   <chr>       <lgl> <lgl>  <lgl>    <chr>       
#> 1 jarvis-15971410 FALSE   FALSE   Mihai Simea FALSE FALSE  FALSE    jarvis-1597…
shows_watching("the-simpsons")
#> # A tibble: 25 × 8
#>    username     private deleted user_name        vip   vip_ep director user_slug
#>    <chr>        <lgl>   <lgl>   <chr>            <lgl> <lgl>  <lgl>    <chr>    
#>  1 mattblack_uk FALSE   FALSE   Harry Keogh      FALSE FALSE  FALSE    mattblac…
#>  2 BriLach7!    FALSE   FALSE   Brilach          FALSE FALSE  FALSE    brilach7 
#>  3 jdallen1226  FALSE   FALSE   James Allen II   FALSE FALSE  FALSE    jdallen1…
#>  4 maxpower212  FALSE   FALSE   maxpower212      FALSE FALSE  FALSE    maxpower…
#>  5 KNGRay123    FALSE   FALSE   Handsome Degaldo FALSE FALSE  FALSE    kngray123
#>  6 ShuntTheRich FALSE   FALSE   ShuntTheRich     FALSE FALSE  FALSE    shuntthe…
#>  7 chriswatts91 FALSE   FALSE   Chris Watts      FALSE FALSE  FALSE    chriswat…
#>  8 slvrflme147  FALSE   FALSE   slvrflme147      FALSE FALSE  FALSE    slvrflme…
#>  9 s9yoeK3CxgF9 FALSE   FALSE   xxx              FALSE FALSE  FALSE    s9yoek3c…
#> 10 brianleb     FALSE   FALSE   Brian            FALSE FALSE  FALSE    brianleb 
#> # ℹ 15 more rows
seasons_watching("the-simpsons", season = 6)
#> # A tibble: 1 × 16
#>   username   private deleted joined_at           location about user_name gender
#>   <chr>      <lgl>   <lgl>   <dttm>              <lgl>    <lgl> <chr>     <lgl> 
#> 1 chriswatt… FALSE   FALSE   2024-08-16 21:05:42 NA       NA    Chris Wa… NA    
#> # ℹ 8 more variables: age <lgl>, vip <lgl>, vip_ep <lgl>,
#> #   vip_cover_image <lgl>, director <lgl>, user_slug <chr>, user_trakt <int>,
#> #   avatar <chr>
episodes_watching("the-simpsons", season = 6, episode = 12)
#> # A tibble: 0 × 0
```
