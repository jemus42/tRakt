# Get a single comment

Get a single comment

## Usage

``` r
comments_comment(id, extended = c("min", "full"))

comments_replies(id, extended = c("min", "full"))

comments_likes(id, extended = c("min", "full"))

comments_item(id, extended = c("min", "full"))
```

## Source

`comments_comment()` wraps endpoint
[/comments/:id](https://trakt.docs.apiary.io/#reference/comments/comment/get-a-comment-or-reply).

`comments_replies()` wraps endpoint
[/comments/:id/replies](https://trakt.docs.apiary.io/#reference/comments/replies/get-replies-for-a-comment).

`comments_likes()` wraps endpoint
[/comments/:id/likes](https://trakt.docs.apiary.io/#reference/comments/likes/get-all-users-who-liked-a-comment).

`comments_item()` wraps endpoint
[/comments/:id/item](https://trakt.docs.apiary.io/#reference/comments/item/get-the-attached-media-item).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

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

## Functions

- `comments_replies()`: Get a comment's replies

- `comments_likes()`: Get users who liked a comment.

- `comments_item()`: Get the media item attached to the comment.

## See also

Other comment methods:
[`comments_trending()`](https://jemus42.github.io/tRakt/reference/comments_trending.md),
[`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)

Other summary methods:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md)

Other comment methods:
[`comments_trending()`](https://jemus42.github.io/tRakt/reference/comments_trending.md),
[`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)

Other comment methods:
[`comments_trending()`](https://jemus42.github.io/tRakt/reference/comments_trending.md),
[`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)

Other comment methods:
[`comments_trending()`](https://jemus42.github.io/tRakt/reference/comments_trending.md),
[`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)

## Examples

``` r
# A single comment
comments_comment("236397")
#> # A tibble: 1 × 19
#>       id comment                    spoiler review parent_id created_at         
#>    <int> <chr>                      <lgl>   <lgl>      <int> <dttm>             
#> 1 236397 All the gun inflicted dea… FALSE   FALSE          0 2019-06-09 21:33:00
#> # ℹ 13 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>

# Multiple comments
comments_comment(c("236397", "112561"))
#> # A tibble: 2 × 19
#>       id comment                    spoiler review parent_id created_at         
#>    <int> <chr>                      <lgl>   <lgl>      <int> <dttm>             
#> 1 236397 All the gun inflicted dea… FALSE   FALSE          0 2019-06-09 21:33:00
#> 2 112561 Seriously though what the… FALSE   FALSE          0 2017-01-31 17:48:59
#> # ℹ 13 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>
if (FALSE) { # \dontrun{
comments_replies("236397")
} # }
if (FALSE) { # \dontrun{
comments_likes("236397")
} # }
if (FALSE) { # \dontrun{
# A movie
comments_item("236397")
comments_item("236397", extended = "full")

# A show
comments_item("120768")
comments_item("120768", extended = "full")

# A season
comments_item("140265")
comments_item("140265", extended = "full")

# An episode
comments_item("136632")
comments_item("136632", extended = "full")
} # }
```
