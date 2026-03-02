# Get a user's watchlist

Get a user's watchlist

## Usage

``` r
user_watchlist(
  user = "me",
  type = c("movies", "shows"),
  extended = c("min", "full")
)
```

## Source

`user_watchlist()` wraps endpoint
[/users/:id/watchlist/:type/:sort](https://trakt.docs.apiary.io/#reference/users/watchlist/get-watchlist).

## Arguments

- user:

  `character(1)`: Target username (or `slug`). Defaults to `"me"`, the
  OAuth user. Can also be of length greater than 1, in which case the
  function is called on all `user` values separately and the result is
  combined.

- type:

  `character(1)`: Either `"shows"` or `"movies"`. For
  season/episode-specific functions, values `seasons` or `episodes` are
  also allowed.

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

Other user data:
[`user_collection()`](https://jemus42.github.io/tRakt/reference/user_collection.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_history()`](https://jemus42.github.io/tRakt/reference/user_history.md),
[`user_likes()`](https://jemus42.github.io/tRakt/reference/user_likes.md),
[`user_network()`](https://jemus42.github.io/tRakt/reference/user_network.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md),
[`user_ratings()`](https://jemus42.github.io/tRakt/reference/user_ratings.md),
[`user_stats()`](https://jemus42.github.io/tRakt/reference/user_stats.md),
[`user_watched()`](https://jemus42.github.io/tRakt/reference/user_watched.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Defaults to movie watchlist and minimal info
user_watchlist(user = "sean")
} # }
```
