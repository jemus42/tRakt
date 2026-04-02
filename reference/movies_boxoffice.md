# Get the weekend box office

Returns the top 10 grossing movies in the U.S. box office last weekend.
Updated every Monday morning.

## Usage

``` r
movies_boxoffice(extended = "min")
```

## Source

`movies_boxoffice()` wraps endpoint
[/movies/boxoffice](https://trakt.docs.apiary.io/#reference/movies/box-office/get-the-weekend-box-office).

## Arguments

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
#>  1 29000000 "Hoppers"                               2026 1085… hopp… tt26… 1327…
#>  2 18000000 "Reminders of Him"                      2026 1116… remi… tt33… 1367…
#>  3  9300000 "undertone"                             2026 1213… unde… tt35… 1480…
#>  4  8400000 "Scream 7"                              2026 9341… scre… tt27… 1159…
#>  5  4700000 "GOAT"                                  2026 1057… goat… tt27… 1297…
#>  6  2100000 "The Bride!"                            2026 9345… the-… tt30… 1159…
#>  7  1700000 "Kiki's Delivery Service"               1989 10314 kiki… tt00… 16859
#>  8  1700000 "\"Wuthering Heights\""                 2026 1077… wuth… tt32… 1316…
#>  9  1500000 "Teenage Mutant Ninja Turtles II: The…  1991 991   teen… tt01… 1497 
#> 10  1100000 "Crime 101"                             2026 9440… crim… tt32… 1171…
```
