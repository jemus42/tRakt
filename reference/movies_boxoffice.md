# Get the weekend box office

Returns the top 10 grossing movies in the U.S. box office last weekend.
Updated every Monday morning.

## Usage

``` r
movies_boxoffice(extended = c("min", "full"))
```

## Source

`movies_boxoffice()` wraps endpoint
[/movies/boxoffice](https://trakt.docs.apiary.io/#reference/movies/box-office/get-the-weekend-box-office).

## Arguments

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
[`movies_related()`](https://jemus42.github.io/tRakt/reference/movies_related.md),
[`movies_releases()`](https://jemus42.github.io/tRakt/reference/movies_releases.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

## Examples

``` r
movies_boxoffice()
#> # A tibble: 10 × 7
#>     revenue title                                   year trakt slug  imdb  tmdb 
#>       <int> <chr>                                  <int> <chr> <chr> <chr> <chr>
#>  1 64000000 "Scream 7"                              2026 9341… scre… tt27… 1159…
#>  2 12000000 "GOAT"                                  2026 1057… goat… tt27… 1297…
#>  3  7000000 "\"Wuthering Heights\""                 2026 1077… wuth… tt32… 1316…
#>  4  4300000 "Twenty One Pilots: More Than We Ever…  2026 1339… twen… tt39… 1612…
#>  5  3500000 "EPiC: Elvis Presley in Concert"        2026 1183… epic… tt35… 1445…
#>  6  3400000 "Crime 101"                             2026 9440… crim… tt32… 1171…
#>  7  3100000 "I Can Only Imagine 2"                  2026 1184… i-ca… tt34… 1405…
#>  8  2800000 "Send Help"                             2026 9678… send… tt80… 1198…
#>  9  1600000 "How to Make a Killing"                 2026 3151… how-… tt43… 4679…
#> 10  1400000 "Zootopia 2"                            2025 8714… zoot… tt26… 1084…
```
