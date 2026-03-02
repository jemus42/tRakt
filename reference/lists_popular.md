# Get popular / trending lists

Get popular / trending lists

## Usage

``` r
lists_popular(limit = 10)

lists_trending(limit = 10)
```

## Source

`lists_popular()` wraps endpoint
[/lists/popular](https://trakt.docs.apiary.io/#reference/lists/popular/get-popular-lists).

`lists_trending()` wraps endpoint
[/lists/trending](https://trakt.docs.apiary.io/#reference/lists/trending/get-trending-lists).

## Arguments

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## See also

[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md)
For the actual content of a list.

Other list methods:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

Other dynamic lists:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other list methods:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

Other dynamic lists:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

## Examples

``` r
if (FALSE) { # \dontrun{
lists_popular()
lists_trending()
} # }
```
