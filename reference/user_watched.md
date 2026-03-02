# Get a user's watched shows or movies

For private users, an [authenticated
request](https://jemus42.github.io/tRakt/reference/trakt_credentials.md)
is required.

## Usage

``` r
user_watched(
  user = "me",
  type = c("shows", "movies"),
  noseasons = TRUE,
  extended = c("min", "full")
)
```

## Source

`user_watched()` wraps endpoint
[/users/:id/watched/:type](https://trakt.docs.apiary.io/#reference/users/watched/get-watched).

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

- noseasons:

  `logical(1) [TRUE]`: Only for `type = "show"`: Exclude detailed season
  data from output. This is advisable if you do not need per-episode
  data and want to be nice to the API.

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
[`user_watchlist()`](https://jemus42.github.io/tRakt/reference/user_watchlist.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Use noseasons = TRUE to avoid receiving detailed season/episode data
user_watched(user = "sean", noseasons = TRUE)
} # }
```
