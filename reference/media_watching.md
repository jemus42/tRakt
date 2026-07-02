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
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md)

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
#>   username          private deleted user_name    vip   vip_ep director user_slug
#>   <chr>             <lgl>   <lgl>   <chr>        <lgl> <lgl>  <lgl>    <chr>    
#> 1 Tonymontana131313 FALSE   FALSE   Anthony Wil… FALSE FALSE  FALSE    tonymont…
shows_watching("the-simpsons")
#> # A tibble: 37 × 8
#>    username      private deleted user_name       vip   vip_ep director user_slug
#>    <chr>         <lgl>   <lgl>   <chr>           <lgl> <lgl>  <lgl>    <chr>    
#>  1 Ashamaly      FALSE   FALSE   Ashamaly        FALSE FALSE  FALSE    ashamaly 
#>  2 Rau09         FALSE   FALSE   Rau09           FALSE FALSE  FALSE    rau09    
#>  3 artur araujo  FALSE   FALSE   Deus Junior (T… FALSE FALSE  FALSE    artur-ar…
#>  4 modemhead     TRUE    FALSE   NA              NA    NA     NA       modemhead
#>  5 Animating3517 FALSE   FALSE   Animating3517   FALSE FALSE  FALSE    animatin…
#>  6 paddy2019     FALSE   FALSE   Patrick Flynn   FALSE FALSE  FALSE    paddy2019
#>  7 SlinkyTron    FALSE   FALSE   Zoidy           FALSE FALSE  FALSE    slinkytr…
#>  8 KTBtv         FALSE   FALSE   KTBtv           FALSE FALSE  FALSE    ktbtv    
#>  9 Neo           FALSE   FALSE   luciano Bouter… FALSE FALSE  FALSE    neo      
#> 10 heavy112      FALSE   FALSE   Heavy           FALSE FALSE  FALSE    heavy112 
#> # ℹ 27 more rows
seasons_watching("the-simpsons", season = 6)
#> # A tibble: 1 × 16
#>   username   private deleted joined_at           location about user_name gender
#>   <chr>      <lgl>   <lgl>   <dttm>              <chr>    <lgl> <chr>     <chr> 
#> 1 Dabomb1001 FALSE   FALSE   2023-07-12 00:52:46 Waterlo… NA    Dabomb    male  
#> # ℹ 8 more variables: age <int>, vip <lgl>, vip_ep <lgl>,
#> #   vip_cover_image <lgl>, director <lgl>, user_slug <chr>, user_trakt <int>,
#> #   avatar <chr>
episodes_watching("the-simpsons", season = 6, episode = 12)
#> # A tibble: 0 × 0
```
