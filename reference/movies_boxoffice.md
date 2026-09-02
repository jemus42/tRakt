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
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

## Examples

``` r
movies_boxoffice()
#> # A tibble: 10 × 7
#>     revenue title                          year trakt   slug         imdb  tmdb 
#>       <int> <chr>                         <int> <chr>   <chr>        <chr> <chr>
#>  1 22000000 Spider-Man: Brand New Day      2026 905132  spider-man-… tt22… 9696…
#>  2 15000000 Coyote vs. Acme                2026 970531  coyote-vs-a… tt17… 1204…
#>  3 14000000 The Odyssey                    2026 1117351 the-odyssey… tt33… 1368…
#>  4 10000000 Insidious: Out of the Further  2026 1051116 insidious-o… tt32… 1291…
#>  5  8000000 The Dog Stars                  2026 1131132 the-dog-sta… tt21… 1384…
#>  6  5400000 Buddy                          2026 1242094 buddy-2026   tt37… 1514…
#>  7  5000000 The End of Oak Street          2026 885985  the-end-of-… tt27… 1101…
#>  8  4900000 PAW Patrol: The Dino Movie     2026 956219  paw-patrol-… tt29… 1185…
#>  9  2800000 Mutiny                         2026 1048396 mutiny-2026  tt32… 1288…
#> 10  2200000 Tony                           2026 1087296 tony-2026    tt33… 1329…
```
