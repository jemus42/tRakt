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
#>  1 episode 969857 "Pues así 😲 qued… FALSE   FALSE          0 2026-07-02 22:42:36
#>  2 episode 969854 "Aun que fue un … FALSE   FALSE          0 2026-07-02 22:40:17
#>  3 episode 969853 "altrought its t… FALSE   FALSE          0 2026-07-02 22:38:41
#>  4 episode 969848 "These thugs at … TRUE    FALSE          0 2026-07-02 22:35:54
#>  5 episode 969846 "That was the mo… FALSE   FALSE          0 2026-07-02 22:34:23
#>  6 movie   969856 "FOR THE LOVE OF… FALSE   FALSE          0 2026-07-02 22:41:52
#>  7 movie   969855 "Como pode um fi… FALSE   FALSE          0 2026-07-02 22:40:48
#>  8 movie   969852 "the car scene g… FALSE   FALSE          0 2026-07-02 22:38:25
#>  9 movie   969847 "Well. She was d… FALSE   FALSE          0 2026-07-02 22:35:39
#> 10 show    969851 "Meu Deus eu ach… FALSE   FALSE          0 2026-07-02 22:37:40
#> # ℹ 27 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>, title <chr>, year <int>, trakt <chr>, slug <chr>,
#> #   tvdb <chr>, imdb <chr>, tmdb <chr>, episode_season <int>,
#> #   episode_number <int>, episode_title <chr>, episode_trakt <chr>,
#> #   episode_tvdb <chr>, episode_imdb <chr>, episode_tmdb <chr>
```
