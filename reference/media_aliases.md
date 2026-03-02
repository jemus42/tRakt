# Get all movie / show aliases

Get all movie / show aliases

## Usage

``` r
movies_aliases(id)

shows_aliases(id)
```

## Source

`movies_aliases()` wraps endpoint
[/movies/:id/aliases](https://trakt.docs.apiary.io/#reference/movies/aliases/get-all-movie-aliases).

`shows_aliases()` wraps endpoint
[/shows/:id/aliases](https://trakt.docs.apiary.io/#reference/shows/summary/get-all-show-aliases).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
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

Other show data:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
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
movies_aliases(190430)
#> # A tibble: 30 × 2
#>    title                   country
#>    <chr>                   <chr>  
#>  1 X-Men Origins: Deadpool us     
#>  2 X-Men: Deadpool         us     
#>  3 Deadpool                br     
#>  4 Дедпул                  bg     
#>  5 Dedpul                  rs     
#>  6 Дэдпул                  ru     
#>  7 惡棍英雄：死侍          tw     
#>  8 死侍：不死现身          cn     
#>  9 X战警：死侍             cn     
#> 10 Deadpool 1              us     
#> # ℹ 20 more rows
shows_aliases(104439)
#> # A tibble: 713 × 2
#>    title                   country
#>    <chr>                   <chr>  
#>  1 Очень странные дела     us     
#>  2 Странные вещи           us     
#>  3 Загадкові справи        ua     
#>  4 Keisti dalykai          lt     
#>  5 Крайне странные события ru     
#>  6 უცნაური საქმეები        ge     
#>  7 Stranger Things (2016)  cn     
#>  8 Stranger Things         cn     
#>  9 Странные вещи           ru     
#> 10 Крайне странные события ru     
#> # ℹ 703 more rows
```
