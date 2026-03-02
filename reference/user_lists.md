# Get a user's lists

Retrieve all lists a user has created together with information about
the user. Use `extended = "full"` to retrieve all user profile data,
similiar to
[user_profile](https://jemus42.github.io/tRakt/reference/user_profile.md).
The returned variables `trakt` (list ID) or `slug` (list slug) can be
used to retrieve the list's items via
[user_list_items](https://jemus42.github.io/tRakt/reference/user_list_items.md).

## Usage

``` r
user_lists(user = "me", extended = c("min", "full"))
```

## Source

`user_lists()` wraps endpoint
[/users/:id/lists](https://trakt.docs.apiary.io/#reference/users/lists/get-a-user).

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

In the embedded user data, `name` is renamed to `user_name` due to
duplication with e.g. list names, and `slug` is renamed to `user_slug`
for the same reason.

## See also

user_lists for all lists a user has.

[user_list_items](https://jemus42.github.io/tRakt/reference/user_list_items.md)
For the actual content of a list.

Other list methods:
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md)

## Examples

``` r
if (FALSE) { # \dontrun{
user_lists("jemus42")
} # }
```
