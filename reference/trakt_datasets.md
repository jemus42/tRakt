# Cached filter datasets

These datasets are used internally to check the optional [filter
parameters](https://trakt.docs.apiary.io/#introduction/filters) for
certain functions (see
[search_query](https://jemus42.github.io/tRakt/reference/search_query.md)
or the dynamic lists like
[shows_popular](https://jemus42.github.io/tRakt/reference/popular_media.md)).
They are unlikely to change often and are therefore included as package
datasets.

## Usage

``` r
trakt_genres

trakt_languages

trakt_networks

trakt_countries

trakt_certifications
```

## Format

Every dataset is a
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
The following list includes the dataset topic with a link to the API
documentation, a short description and a list of variables with example
values:

- [Genres](https://trakt.docs.apiary.io/#reference/genres/list/get-genres):
  Genres for shows and movies (with their two-letter codes) trakt.tv
  knows.

  - 3 Variables: `name` ("Action"), `slug` ("action"), `type` ("movies")

- [Languages](https://trakt.docs.apiary.io/#reference/languages/list):
  Languages (and two-letter codes) trakt.tv knows.

  - 3 Variables: `name` ("Arabic"), `code` ("ar"), `type` ("movies")

- [Networks](https://trakt.docs.apiary.io/#reference/networks/list): TV
  networks trakt.tv knows.

  - 2 Variables: `name` ("TBS"), `name_clean` ("tbs") (lower-case, no
    trailing whitespaces)

- [Countries](https://trakt.docs.apiary.io/#reference/countries/list):
  Country names (and two-letter codes).

  - 3 Variables: `name` ("Belarus"), `code` ("by"), `type` ("movies")

- [Certifications](https://trakt.docs.apiary.io/#reference/certifications/list):
  TV and movie certifications (e.g. "PG-13" and the likes).

  - 5 Variables: `country` ("us" only), `name` ("TV-PG"), `slug`
    ("tv-pg"), `description` ("Parental Guidance Suggested"), `type`
    ("shows")

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 64
rows and 3 columns.

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 297
rows and 3 columns.

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
4526 rows and 5 columns.

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 377
rows and 3 columns.

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 12
rows and 5 columns.

## Details

The datasets are prefixed with `trakt_` purely to avoid confusion or
masking for filter arguments of the same name.

## Note

Currently only US certifications are available.

## Examples

``` r
head(trakt_genres)
#> # A tibble: 6 × 3
#>   name      slug      type  
#>   <chr>     <chr>     <chr> 
#> 1 Action    action    movies
#> 2 Action    action    shows 
#> 3 Adventure adventure movies
#> 4 Adventure adventure shows 
#> 5 Animation animation movies
#> 6 Animation animation shows 
head(trakt_languages)
#> # A tibble: 6 × 3
#>   name      code  type  
#>   <chr>     <chr> <chr> 
#> 1 Afar      aa    movies
#> 2 Afar      aa    shows 
#> 3 Abkhazian ab    movies
#> 4 Abkhazian ab    shows 
#> 5 Avestan   ae    movies
#> 6 Afrikaans af    movies
head(trakt_networks)
#> # A tibble: 6 × 5
#>   name       name_clean country trakt  tmdb
#>   <chr>      <chr>      <chr>   <int> <int>
#> 1 ""         ""         NA        869  1446
#> 2 " 10 Play" "10 play"  au       1287  3466
#> 3 " VTV "    "vtv"      vn        481  2863
#> 4 "&CAST!!!" "&cast!!!" jp       4453  8051
#> 5 "&TV"      "&tv"      in       1489  1566
#> 6 "#0"       "#0"       es         79  2140
head(trakt_countries)
#> # A tibble: 6 × 3
#>   name                 code  type  
#>   <chr>                <chr> <chr> 
#> 1 Andorra              ad    movies
#> 2 Andorra              ad    shows 
#> 3 United Arab Emirates ae    movies
#> 4 United Arab Emirates ae    shows 
#> 5 Afghanistan          af    movies
#> 6 Afghanistan          af    shows 
trakt_certifications
#> # A tibble: 12 × 5
#>    country name      slug  description                                     type 
#>    <chr>   <chr>     <chr> <chr>                                           <chr>
#>  1 us      G         g     All Ages                                        movi…
#>  2 us      PG        pg    Parental Guidance Suggested                     movi…
#>  3 us      PG-13     pg-13 Parents Strongly Cautioned - Ages 13+ Recommen… movi…
#>  4 us      R         r     Mature Audiences - Ages 17+ Recommended         movi…
#>  5 us      Not Rated nr    Not Rated                                       movi…
#>  6 us      TV-Y      tv-y  All Children                                    shows
#>  7 us      TV-Y7     tv-y7 Older Children - Ages 7+ Recommended            shows
#>  8 us      TV-G      tv-g  All Ages                                        shows
#>  9 us      TV-PG     tv-pg Parental Guidance Suggested                     shows
#> 10 us      TV-14     tv-14 Parents Strongly Cautioned - Ages 14+ Recommen… shows
#> 11 us      TV-MA     tv-ma Mature Audiences - Ages 17+ Recommended         shows
#> 12 us      Not Rated nr    Not Rated                                       shows
```
