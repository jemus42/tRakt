# Get a user's social connections

Get followers, followings or friends (the two-way relationship).

## Usage

``` r
user_followers(user = getOption("trakt_user"), extended = "min")

user_following(user = getOption("trakt_user"), extended = "min")

user_friends(user = getOption("trakt_user"), extended = "min")
```

## Source

`user_followers()` wraps endpoint
[/users/:id/followers](https://trakt.docs.apiary.io/#reference/users/followers/get-followers).

`user_following()` wraps endpoint
[/users/:id/following](https://trakt.docs.apiary.io/#reference/users/following/get-following).

`user_friends()` wraps endpoint
[/users/:id/friends](https://trakt.docs.apiary.io/#reference/users/friends/get-friends).

## Arguments

- user:

  `character(1)`: Target username (or `slug`). Defaults to `"me"`, the
  OAuth user. Can also be of length greater than 1, in which case the
  function is called on all `user` values separately and the result is
  combined.

- extended:

  `character`: Level of detail for the API response.

  - `"min"` (default): Minimal info (title, year, IDs). Omits the
    `extended` query param.

  - `"full"`: Complete info including overview, ratings, runtime, etc.

  - `"images"`: Minimal info plus image URLs (returned as a
    list-column).

  - `"full,images"`: Complete info plus images.

  - `"metadata"`: Collection endpoints only; adds video/audio metadata.

  Multiple values can be combined as a comma-separated string (e.g.
  `"full,images"`) or a character vector (e.g. `c("full", "images")`).

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## Note

If the specified user is private, you need to be able to make an
[authenticated
request](https://jemus42.github.io/tRakt/reference/trakt_credentials.md)
and be friends with the user.

## See also

Other user data:
[`user_collection()`](https://jemus42.github.io/tRakt/reference/user_collection.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_history()`](https://jemus42.github.io/tRakt/reference/user_history.md),
[`user_likes()`](https://jemus42.github.io/tRakt/reference/user_likes.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md),
[`user_ratings()`](https://jemus42.github.io/tRakt/reference/user_ratings.md),
[`user_stats()`](https://jemus42.github.io/tRakt/reference/user_stats.md),
[`user_watched()`](https://jemus42.github.io/tRakt/reference/user_watched.md),
[`user_watchlist()`](https://jemus42.github.io/tRakt/reference/user_watchlist.md)

## Examples

``` r
if (FALSE) { # \dontrun{
user_followers(user = "sean")
} # }
if (FALSE) { # \dontrun{
user_following(user = "sean")
} # }
if (FALSE) { # \dontrun{
user_friends(user = "sean")
} # }
```
