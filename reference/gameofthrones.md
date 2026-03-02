# Game of Thrones episodes

This data comes from <https://trakt.tv> and
<https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_episodes>.

## Usage

``` r
gameofthrones
```

## Format

A [tibble()](https://tibble.tidyverse.org/reference/tibble-package.html)
with 67 rows and 17 variables:

- episode_abs:

  Overall episode number

- episode, season:

  Episode within each season and season number

- title:

  Episode title

- overview:

  Episode summary

- rating:

  Rating (1-10) on trakt.tv

- votes:

  Number of votes ontrakt.tv

- viewers:

  Viewers according to Wikipedia

- director, writer:

  Directing and writing credits

- comment_count:

  Number of comments on episode page

- first_aired, updated_at:

  Original air date and last update in UTC as `POSIXct`

- runtime:

  Runtime in minutes

- trakt, tvdb, tmdb:

  Episode IDs for trakt.tv, TVDb, and TMDb

- year:

  Year of first airing

- epid:

  Episode ID in `s00e00` format

## See also

Other Episode datasets:
[`futurama`](https://jemus42.github.io/tRakt/reference/futurama.md)

## Examples

``` r
gameofthrones
#> # A tibble: 73 × 18
#>    episode_abs episode season runtime title        overview rating votes viewers
#>          <int>   <int>  <int>   <int> <chr>        <chr>     <dbl> <int>   <dbl>
#>  1           1       1      1      62 Winter Is C… Jon Arr…   8.08 15179    2.22
#>  2           2       2      1      56 The Kingsro… While B…   8.10 11862    2.2 
#>  3           3       3      1      58 Lord Snow    Lord St…   8.01 10924    2.44
#>  4           4       4      1      56 Cripples, B… Eddard …   8.05 10502    2.45
#>  5           5       5      1      55 The Wolf an… Catelyn…   8.09 10149    2.58
#>  6           6       6      1      53 A Golden Cr… While r…   8.28 10144    2.44
#>  7           7       7      1      58 You Win or … Robert …   8.25  9932    2.4 
#>  8           8       8      1      59 The Pointy … Eddard …   8.11  9593    2.72
#>  9           9       9      1      57 Baelor       Robb go…   8.36  9635    2.66
#> 10          10      10      1      53 Fire and Bl… With Ne…   8.55  9722    3.04
#> # ℹ 63 more rows
#> # ℹ 9 more variables: director <chr>, writer <chr>, first_aired <dttm>,
#> #   comment_count <int>, trakt <chr>, imdb <chr>, tvdb <chr>, tmdb <chr>,
#> #   updated_at <dttm>
```
