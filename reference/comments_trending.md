# Get trending or recently made comments

Get trending or recently made comments

## Usage

``` r
comments_trending(
  comment_type = c("all", "reviews", "shouts"),
  type = c("all", "movies", "shows", "seasons", "episodes", "lists"),
  include_replies = FALSE,
  limit = 10L
)

comments_recent(
  comment_type = c("all", "reviews", "shouts"),
  type = c("all", "movies", "shows", "seasons", "episodes", "lists"),
  include_replies = FALSE,
  limit = 10L
)
```

## Source

`comments_trending()` wraps endpoint
[/comments/trending/:comment_type/:type?include_replies=](https://trakt.docs.apiary.io/#reference/comments/trending/get-trending-comments).

`comments_recent()` wraps endpoint
[/comments/recent/:comment_type/:type?include_replies=](https://trakt.docs.apiary.io/#reference/comments/recent/get-recently-created-comments).

## Arguments

- comment_type:

  `character(1) ["all"]`: The type of comment, one of "all", "reviews"
  or "shouts".

- type:

  `character(1) ["all"]`: The type of media to filter by, one of "all",
  "movies", "shows", "seasons", "episodes" or "lists".

- include_replies:

  `logical(1) [FALSE]`: Whether to include replies.

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

Other comment methods:
[`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md),
[`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)

Other comment methods:
[`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md),
[`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Trending reviews
comments_trending("reviews")

# Recent shouts (short comments)
comments_recent("shouts")
} # }
```
