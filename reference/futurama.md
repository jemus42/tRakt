# Futurama episodes

This data comes from <https://trakt.tv> and serves as an example of
episode data output.

## Usage

``` r
futurama
```

## Format

A [tibble()](https://tibble.tidyverse.org/reference/tibble-package.html)
with 124 rows and 18 variables:

- episode, season:

  Episode within each season and season number

- title:

  Episode title

- episode_abs:

  Overall episode number

- overview:

  Episode summary

- rating:

  Rating (1-10) on trakt.tv

- votes:

  Number of votes ontrakt.tv

- comment_count:

  Number of comments on episode page

- first_aired, updated_at:

  Original air date and last update in UTC as `POSIXct`

- runtime:

  Runtime in minutes

- trakt, tvdb, tmdb:

  Episode IDs for trakt.tv, TVDb, and TMDb

- available_translations:

  List-column of available translation on trakt.tv

## See also

Other Episode datasets:
[`gameofthrones`](https://jemus42.github.io/tRakt/reference/gameofthrones.md)

## Examples

``` r
futurama
#> # A tibble: 144 × 17
#>    season episode title          episode_abs overview rating votes comment_count
#>     <int>   <int> <chr>                <int> <chr>     <dbl> <int>         <int>
#>  1      1       1 Space Pilot 3…           1 "On New…   8.11  2657             5
#>  2      1       2 The Series Ha…           2 "For th…   7.81  2163             4
#>  3      1       3 I, Roommate              3 "When i…   7.84  1962             2
#>  4      1       4 Love's Labour…           4 "On a m…   7.72  1784             5
#>  5      1       5 Fear of a Bot…           5 "Fry an…   7.66  1715             1
#>  6      1       6 A Fishful of …           6 "Fry di…   7.73  1700             3
#>  7      1       7 My Three Suns            7 "Delive…   7.63  1569             2
#>  8      1       8 A Big Piece o…           8 "A big …   7.75  1545             1
#>  9      1       9 Hell Is Other…           9 "During…   7.83  1526             2
#> 10      2       1 A Flight to R…          10 "The Pl…   7.81  1579             1
#> # ℹ 134 more rows
#> # ℹ 9 more variables: first_aired <dttm>, updated_at <dttm>,
#> #   available_translations <list>, runtime <int>, episode_type <chr>,
#> #   trakt <chr>, tvdb <chr>, imdb <chr>, tmdb <chr>
```
