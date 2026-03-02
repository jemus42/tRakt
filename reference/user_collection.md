# Get a user's collected shows or movies

Get a user's collected shows or movies

## Usage

``` r
user_collection(
  user = "me",
  type = c("shows", "movies"),
  unnest_episodes = FALSE,
  extended = c("min", "full")
)
```

## Source

`user_collection()` wraps endpoint
[/users/:id/collection/:type](https://trakt.docs.apiary.io/#reference/users/collection/get-collection).

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

- unnest_episodes:

  `logical(1) [FALSE]`: Unnests episode data using
  [`tidyr::unnest()`](https://tidyr.tidyverse.org/reference/unnest.html)
  and returns one row per episode rather than one row per show.

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
[`/users/:user_id/collection/:type`](https://trakt.docs.apiary.io/#reference/users/collection/get-collection).

## Note

The `extended = "metadata"` API parameter is not implemented. This would
add media information `media_type`, `resolution`, `audio`,
`audio_channels` and `3D` to the output, which may or may not be
available. If this feature is important to you, please open an issue on
GitHub.

## See also

Other user data:
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_history()`](https://jemus42.github.io/tRakt/reference/user_history.md),
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
user_collection(user = "sean", type = "movies")
user_collection(user = "sean", type = "shows")
} # }
```
