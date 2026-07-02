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
#>  1 episode 969843 "I want to know … FALSE   FALSE          0 2026-07-02 22:32:26
#>  2 episode 969842 "Cried and laugh… FALSE   FALSE          0 2026-07-02 22:31:58
#>  3 episode 969837 "The first minut… FALSE   FALSE          0 2026-07-02 22:30:50
#>  4 episode 969833 "Ohhh. So the pr… FALSE   FALSE          0 2026-07-02 22:29:54
#>  5 movie   969840 "It was pretty b… FALSE   FALSE          0 2026-07-02 22:31:21
#>  6 movie   969838 "idk if I enjoye… FALSE   FALSE          0 2026-07-02 22:31:05
#>  7 movie   969832 "فيلم كوميدي ممت… FALSE   FALSE          0 2026-07-02 22:29:47
#>  8 show    969835 "I was really im… FALSE   FALSE          0 2026-07-02 22:30:09
#>  9 show    969830 "Mi Némesis con … FALSE   FALSE          0 2026-07-02 22:28:59
#> 10 show    969829 "Mi Némesis con … FALSE   FALSE          0 2026-07-02 22:28:33
#> # ℹ 27 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>, title <chr>, year <int>, trakt <chr>, slug <chr>,
#> #   tvdb <chr>, imdb <chr>, tmdb <chr>, episode_season <int>,
#> #   episode_number <int>, episode_title <chr>, episode_trakt <chr>,
#> #   episode_tvdb <chr>, episode_imdb <chr>, episode_tmdb <chr>
```
