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

## Examples

``` r
# Trending reviews
comments_trending("reviews")
#> # A tibble: 10 × 34
#>    type         id comment          spoiler review parent_id created_at         
#>    <chr>     <int> <chr>            <lgl>   <lgl>      <int> <dttm>             
#>  1 episode 1038302 "REVIEW\nI'm so… FALSE   TRUE           0 2026-08-31 06:27:03
#>  2 episode 1032108 "So far, this i… TRUE    TRUE           0 2026-08-24 03:00:00
#>  3 episode 1035711 "WTF?! It seems… FALSE   TRUE           0 2026-08-28 11:46:35
#>  4 episode 1031289 "Ichigo, who is… TRUE    TRUE           0 2026-08-23 07:27:26
#>  5 episode 1001678 "These episodes… TRUE    TRUE           0 2026-07-25 07:34:21
#>  6 episode  885289 "[6.8/10] Let’s… TRUE    TRUE           0 2025-11-13 22:02:48
#>  7 episode 1023066 "What an absolu… FALSE   TRUE           0 2026-08-14 01:38:01
#>  8 episode 1029010 "Apparently I'm… FALSE   TRUE           0 2026-08-20 18:38:36
#>  9 episode  933954 "[85/100] The f… TRUE    TRUE           0 2026-03-13 04:10:03
#> 10 movie   1023418 "I liked this w… FALSE   TRUE           0 2026-08-14 14:06:13
#> # ℹ 27 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>, title <chr>, year <int>, trakt <chr>, slug <chr>,
#> #   tvdb <chr>, imdb <chr>, tmdb <chr>, episode_season <int>,
#> #   episode_number <int>, episode_title <chr>, episode_trakt <chr>,
#> #   episode_tvdb <chr>, episode_imdb <chr>, episode_tmdb <chr>

# Recent shouts (short comments)
comments_recent("shouts")
#> # A tibble: 10 × 34
#>    type         id comment          spoiler review parent_id created_at         
#>    <chr>     <int> <chr>            <lgl>   <lgl>      <int> <dttm>             
#>  1 episode 1040045 "Oh, Choi could… TRUE    FALSE          0 2026-09-02 12:01:04
#>  2 episode 1040044 "I keep wonderi… TRUE    FALSE          0 2026-09-02 11:58:43
#>  3 episode 1040042 "The boys get s… TRUE    FALSE          0 2026-09-02 11:52:35
#>  4 episode 1040041 "Ofcourse they'… FALSE   FALSE          0 2026-09-02 11:52:09
#>  5 episode 1040040 "The boys go ca… TRUE    FALSE          0 2026-09-02 11:51:28
#>  6 episode 1040039 "bob saget ????… FALSE   FALSE          0 2026-09-02 11:49:27
#>  7 episode 1040036 "Eine Kopie die… FALSE   FALSE          0 2026-09-02 11:37:59
#>  8 episode 1040035 "Júlia correndo… FALSE   FALSE          0 2026-09-02 11:35:46
#>  9 movie   1040038 "Intensely inti… FALSE   FALSE          0 2026-09-02 11:40:29
#> 10 movie   1040037 "This was incre… FALSE   FALSE          0 2026-09-02 11:39:45
#> # ℹ 27 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>, title <chr>, year <int>, trakt <chr>, slug <chr>,
#> #   tvdb <chr>, imdb <chr>, tmdb <chr>, episode_season <int>,
#> #   episode_number <int>, episode_title <chr>, episode_trakt <chr>,
#> #   episode_tvdb <chr>, episode_imdb <chr>, episode_tmdb <chr>
```
