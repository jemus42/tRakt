# Get a user's list's items

Get a user's list's items

## Usage

``` r
user_list_items(user = "me", list_id, type = NULL, extended = c("min", "full"))
```

## Source

`user_list_items()` wraps endpoint
[/users/:id/lists/:list_id/items/:type](https://trakt.docs.apiary.io/#reference/users/list-items/get-items-on-a-custom-list).

## Arguments

- user:

  `character(1)`: Target username (or `slug`). Defaults to `"me"`, the
  OAuth user. Can also be of length greater than 1, in which case the
  function is called on all `user` values separately and the result is
  combined.

- list_id:

  The list identifier, either `trakt` ID or `slug` of the list. Can be
  optained via the website (URL `slug`) or e.g.
  [user_lists](https://jemus42.github.io/tRakt/reference/user_lists.md).

- type:

  `character(1) [NULL]`: If not `NULL`, only items of that media type
  are returned. Possible values are `"movie"`, `"show"`, `"season"`,
  `"episode"`, `"person"`.

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

Other list methods:
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# A large list with various media types
# All items
user_list_items("sp1ti", list_id = "5615781", extended = "min")

# Movies only
user_list_items("sp1ti", list_id = "5615781", extended = "min", type = "movie")

# Shows...
user_list_items("sp1ti", list_id = "5615781", extended = "min", type = "shows")

# Only seasons
user_list_items("sp1ti", list_id = "5615781", extended = "min", type = "season")

# Only episodes
user_list_items("sp1ti", list_id = "5615781", extended = "min", type = "episodes")
} # }
```
