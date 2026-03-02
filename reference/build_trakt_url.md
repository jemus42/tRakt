# Assemble a trakt.tv API URL

`build_trakt_url` assembles a trakt.tv API URL from different arguments.
The result should be fine for use with
[trakt_get](https://jemus42.github.io/tRakt/reference/trakt_get.md),
since that's what this function was created for.

## Usage

``` r
build_trakt_url(...)
```

## Arguments

- ...:

  Unnamed arguments will be concatenated with `/` as separators to form
  the path of the API URL, e.g. the arguments `movies`,
  `tron-legacy-2012` and `releases` will be concatenated to
  `movies/tron-legacy-2012/releases`. Additional **named** arguments
  will be used as query parameters, usually `extended = "full"` or
  others.

## Value

A URL: `character` of length 1.

## See also

Other utility functions:
[`pad_episode()`](https://jemus42.github.io/tRakt/reference/pad_episode.md)

## Examples

``` r
build_trakt_url("shows", "breaking-bad", extended = "full")
#> [1] "https://api.trakt.tv/shows/breaking-bad?extended=full"
build_trakt_url("shows", "popular", page = 3, limit = 5)
#> [1] "https://api.trakt.tv/shows/popular?page=3&limit=5"

# Path can also be partially assembled already
build_trakt_url("users/jemus42", "ratings")
#> [1] "https://api.trakt.tv/users/jemus42/ratings"

build_trakt_url("shows", "popular", page = 1, limit = 5)
#> [1] "https://api.trakt.tv/shows/popular?page=1&limit=5"
```
