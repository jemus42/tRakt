# Returns stats about the movies, shows, and episodes a user has watched, collected, and rated.

Data about a user's interactions with movies, shows, seasons, episodes,
as well as their social network (friends, followings, followers) and a
frequency table of the user's media ratings so far.

## Usage

``` r
user_stats(user = "me")
```

## Source

`user_stats()` wraps endpoint
[/users/:id/stats](https://trakt.docs.apiary.io/#reference/users/stats/get-stats).

## Arguments

- user:

  `character(1)`: Target username (or `slug`). Defaults to `"me"`, the
  OAuth user. Can also be of length greater than 1, in which case the
  function is called on all `user` values separately and the result is
  combined.

## Value

A `list` of
[tibbles](https://tibble.tidyverse.org/reference/tibble-package.html)
containing the following elements:

- "movies"

- "shows"

- "seasons"

- "episodes"

- "network"

- "ratings"

## See also

Other user data:
[`user_collection()`](https://jemus42.github.io/tRakt/reference/user_collection.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_history()`](https://jemus42.github.io/tRakt/reference/user_history.md),
[`user_likes()`](https://jemus42.github.io/tRakt/reference/user_likes.md),
[`user_network()`](https://jemus42.github.io/tRakt/reference/user_network.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md),
[`user_ratings()`](https://jemus42.github.io/tRakt/reference/user_ratings.md),
[`user_watched()`](https://jemus42.github.io/tRakt/reference/user_watched.md),
[`user_watchlist()`](https://jemus42.github.io/tRakt/reference/user_watchlist.md)

## Examples

``` r
if (FALSE) { # \dontrun{
user_stats(user = "sean")
} # }
```
