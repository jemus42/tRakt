# Get a user's profile

Get a user's profile

## Usage

``` r
user_profile(user = "me", extended = c("min", "full"))
```

## Source

`user_profile()` wraps endpoint
[/users/:id](https://trakt.docs.apiary.io/#reference/users/profile/get-user-profile).

## Arguments

- user:

  `character(1)`: Target username (or `slug`). Defaults to `"me"`, the
  OAuth user. Can also be of length greater than 1, in which case the
  function is called on all `user` values separately and the result is
  combined.

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
[`user_network()`](https://jemus42.github.io/tRakt/reference/user_network.md),
[`user_ratings()`](https://jemus42.github.io/tRakt/reference/user_ratings.md),
[`user_stats()`](https://jemus42.github.io/tRakt/reference/user_stats.md),
[`user_watched()`](https://jemus42.github.io/tRakt/reference/user_watched.md),
[`user_watchlist()`](https://jemus42.github.io/tRakt/reference/user_watchlist.md)

Other summary methods:
[`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md),
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
user_profile("sean")
} # }
```
