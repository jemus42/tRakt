# Get a user's watch history

Retrieve a the last `limit` items a user has watched, including the
method by which it was logged (e.g. *scrobble* or *checkin*).

## Usage

``` r
user_history(
  user = "me",
  type = c("shows", "movies", "seasons", "episodes"),
  item_id = NULL,
  limit = 10L,
  start_at = NULL,
  end_at = NULL,
  extended = c("min", "full")
)
```

## Source

`user_history()` wraps endpoint
[/users/:id/history/:type/:item_id?start_at=,end_at=](https://trakt.docs.apiary.io/#reference/users/history/get-watched-history).

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

- item_id:

  `character(1)`: The ID of the item you're looking for.

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

- start_at, end_at:

  `character(1)`: A time-window to filter by. Must be coercible to a
  datetime object of class `POSIXct`. See
  [ISOdate](https://rdrr.io/r/base/ISOdatetime.html) for further
  information.

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

## Details

This function wraps the API method
[`/users/:id/history/:type`](https://trakt.docs.apiary.io/#reference/users/history/get-watched-history).

## Note

For `type = "shows"`, the original output contains a nested object with
`show` and `episode` data, which are unnested by this function. Due to
duplicate variable names, all episode-related variables are prefixed
with `episode_`. This results in the episode number having the name
`episode_episode`, which is quite silly. Sorry.

## See also

Other user data:
[`user_collection()`](https://jemus42.github.io/tRakt/reference/user_collection.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_likes()`](https://jemus42.github.io/tRakt/reference/user_likes.md),
[`user_network()`](https://jemus42.github.io/tRakt/reference/user_network.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md),
[`user_ratings()`](https://jemus42.github.io/tRakt/reference/user_ratings.md),
[`user_stats()`](https://jemus42.github.io/tRakt/reference/user_stats.md),
[`user_watched()`](https://jemus42.github.io/tRakt/reference/user_watched.md),
[`user_watchlist()`](https://jemus42.github.io/tRakt/reference/user_watchlist.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Shows user "jemus42" watched around christmas 2016
user_history(
  user = "jemus42", type = "shows", limit = 5,
  start_at = "2015-12-24", end_at = "2015-12-28"
)
} # }
```
