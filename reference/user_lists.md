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
user_lists(user = "me", extended = "min")
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
