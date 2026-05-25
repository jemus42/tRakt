# Make an API call and receive parsed output

The most basic form of API interaction: Querying a specific URL and
getting its parsed result. If the response is empty, the function
returns an empty
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html),
and if there are date-time variables present in the response, they are
converted to `POSIXct` via
[`lubridate::ymd_hms()`](https://lubridate.tidyverse.org/reference/ymd_hms.html)
or to `Date` via
[`lubridate::as_date()`](https://lubridate.tidyverse.org/reference/as_date.html)
if the variable only contains date information.

## Usage

``` r
trakt_get(url)
```

## Arguments

- url:

  `character(1)`: The API endpoint. Either a full URL like
  `"https://api.trakt.tv/shows/breaking-bad"` or just the endpoint like
  `shows/breaking-bad`.

## Value

The parsed content of the API response. An empty
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html)
if the response is an empty `JSON` array.

## Details

See [the official API reference](https://trakt.docs.apiary.io) for a
detailed overview of available methods. Most methods of potential
interest for data collection have dedicated functions in this package.

## Examples

``` r
# A simple request to a direct URL
trakt_get("https://api.trakt.tv/shows/breaking-bad")
#> $ids
#> $ids$imdb
#> [1] "tt0903747"
#> 
#> $ids$plex
#> $ids$plex$guid
#> [1] "5d9c083402391c001f583d09"
#> 
#> $ids$plex$slug
#> [1] "breaking-bad"
#> 
#> 
#> $ids$slug
#> [1] "breaking-bad"
#> 
#> $ids$tmdb
#> [1] 1396
#> 
#> $ids$tvdb
#> [1] 81189
#> 
#> $ids$trakt
#> [1] 1388
#> 
#> 
#> $year
#> [1] 2008
#> 
#> $title
#> [1] "Breaking Bad"
#> 
#> $aired_episodes
#> [1] 62
#> 

# Optionally be lazy about URL specification by dropping the hostname:
trakt_get("shows/game-of-thrones")
#> $ids
#> $ids$imdb
#> [1] "tt0944947"
#> 
#> $ids$plex
#> $ids$plex$guid
#> [1] "5d9c086c46115600200aa2fe"
#> 
#> $ids$plex$slug
#> [1] "game-of-thrones"
#> 
#> 
#> $ids$slug
#> [1] "game-of-thrones"
#> 
#> $ids$tmdb
#> [1] 1399
#> 
#> $ids$tvdb
#> [1] 121361
#> 
#> $ids$trakt
#> [1] 1390
#> 
#> 
#> $year
#> [1] 2011
#> 
#> $title
#> [1] "Game of Thrones"
#> 
#> $aired_episodes
#> [1] 73
#> 
```
