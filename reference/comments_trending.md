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
#>    type        id comment           spoiler review parent_id created_at         
#>    <chr>    <int> <chr>             <lgl>   <lgl>      <int> <dttm>             
#>  1 movie   967084 "“Kara Zor-El is… TRUE    TRUE           0 2026-06-26 06:24:33
#>  2 movie   967158 "This has been a… FALSE   TRUE           0 2026-06-26 13:27:56
#>  3 episode 959101 "“Sometimes grie… TRUE    TRUE           0 2026-06-01 05:31:38
#>  4 episode 964331 "This was a grea… FALSE   TRUE           0 2026-06-17 07:18:00
#>  5 episode 885289 "[6.8/10] Let’s … TRUE    TRUE           0 2025-11-13 22:02:48
#>  6 episode 933954 "[85/100] The fi… TRUE    TRUE           0 2026-03-13 04:10:03
#>  7 episode 716309 "Random thoughts… TRUE    TRUE           0 2024-09-25 00:17:11
#>  8 episode 426674 "There were a fe… FALSE   TRUE           0 2021-12-11 19:57:16
#>  9 episode 965473 "It made absolut… FALSE   TRUE           0 2026-06-21 05:48:52
#> 10 show    505402 "This show is al… FALSE   TRUE           0 2022-09-27 21:31:52
#> # ℹ 27 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>, title <chr>, year <int>, trakt <chr>, slug <chr>,
#> #   imdb <chr>, tmdb <chr>, tvdb <chr>, episode_season <int>,
#> #   episode_number <int>, episode_title <chr>, episode_trakt <chr>,
#> #   episode_tvdb <chr>, episode_imdb <chr>, episode_tmdb <chr>

# Recent shouts (short comments)
comments_recent("shouts")
#> # A tibble: 10 × 34
#>    type        id comment           spoiler review parent_id created_at         
#>    <chr>    <int> <chr>             <lgl>   <lgl>      <int> <dttm>             
#>  1 show    970866 "This was outsta… FALSE   FALSE          0 2026-07-03 16:17:05
#>  2 show    970863 "This one honest… FALSE   FALSE          0 2026-07-03 16:11:08
#>  3 show    970857 "Foi mini série … FALSE   FALSE          0 2026-07-03 15:49:30
#>  4 episode 970865 "Not a silo but … FALSE   FALSE          0 2026-07-03 16:16:19
#>  5 episode 970864 "Mouth is the wo… TRUE    FALSE          0 2026-07-03 16:13:09
#>  6 episode 970862 "I loved the fal… FALSE   FALSE          0 2026-07-03 16:10:48
#>  7 episode 970861 "I genuinely for… FALSE   FALSE          0 2026-07-03 16:06:17
#>  8 episode 970860 "Ai esse irmão d… FALSE   FALSE          0 2026-07-03 16:00:42
#>  9 episode 970859 "Wow wow what a … FALSE   FALSE          0 2026-07-03 15:56:08
#> 10 episode 970858 "I mean let’s fu… FALSE   FALSE          0 2026-07-03 15:49:45
#> # ℹ 27 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>, title <chr>, year <int>, trakt <chr>, slug <chr>,
#> #   tvdb <chr>, imdb <chr>, tmdb <chr>, episode_season <int>,
#> #   episode_number <int>, episode_title <chr>, episode_trakt <chr>,
#> #   episode_tvdb <chr>, episode_imdb <chr>, episode_tmdb <chr>
```
