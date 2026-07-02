# Get a single comment

Get a single comment

## Usage

``` r
comments_comment(id, extended = "min")

comments_replies(id, extended = "min")

comments_likes(id, extended = "min")

comments_item(id, extended = "min")
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
comments_replies("236397")
#> # A tibble: 1 × 19
#>       id comment                    spoiler review parent_id created_at         
#>    <int> <chr>                      <lgl>   <lgl>      <int> <dttm>             
#> 1 250976 "@jemus42  That scene is … FALSE   FALSE     236397 2019-09-18 02:57:44
#> # ℹ 13 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>
comments_likes("236397")
#> # A tibble: 1 × 9
#>   liked_at    username private deleted user_name vip   vip_ep director user_slug
#>   <chr>       <chr>    <lgl>   <lgl>   <chr>     <lgl> <lgl>  <lgl>    <chr>    
#> 1 2019-09-15… OvejaMe… FALSE   FALSE   Laura     FALSE FALSE  FALSE    ovejamec…
# A movie
comments_item("236397")
#> # A tibble: 1 × 7
#>   type  title                              year trakt  slug          imdb  tmdb 
#>   <chr> <chr>                             <int> <chr>  <chr>         <chr> <chr>
#> 1 movie John Wick: Chapter 3 - Parabellum  2019 304278 john-wick-ch… tt61… 4581…
comments_item("236397", extended = "full")
#> # A tibble: 1 × 28
#>   type  title     year tagline overview released   runtime country status rating
#>   <chr> <chr>    <int> <chr>   <chr>    <date>       <int> <chr>   <chr>   <dbl>
#> 1 movie John Wi…  2019 If you… Super-a… 2019-05-17     131 us      relea…   7.61
#> # ℹ 18 more variables: votes <int>, comment_count <int>, trailer <chr>,
#> #   homepage <chr>, updated_at <dttm>, language <chr>, languages <list>,
#> #   available_translations <list>, genres <list>, subgenres <list>,
#> #   certification <chr>, original_title <chr>, after_credits <lgl>,
#> #   during_credits <lgl>, trakt <chr>, slug <chr>, imdb <chr>, tmdb <chr>

# A show
comments_item("120768")
#> # A tibble: 1 × 8
#>   type  title           year trakt  slug           tvdb   imdb      tmdb 
#>   <chr> <chr>          <int> <chr>  <chr>          <chr>  <chr>     <chr>
#> 1 show  13 Reasons Why  2017 116129 13-reasons-why 323168 tt1837492 66788
comments_item("120768", extended = "full")
#> # A tibble: 1 × 33
#>   type  title    year tagline overview first_aired         runtime total_runtime
#>   <chr> <chr>   <int> <chr>   <chr>    <dttm>                <int>         <int>
#> 1 show  13 Rea…  2017 If you… High sc… 2017-03-31 07:00:00      60          2868
#> # ℹ 25 more variables: certification <chr>, country <chr>, status <chr>,
#> #   rating <dbl>, votes <int>, comment_count <int>, trailer <chr>,
#> #   homepage <chr>, network <chr>, updated_at <dttm>, language <chr>,
#> #   languages <list>, available_translations <list>, genres <list>,
#> #   subgenres <list>, aired_episodes <int>, original_title <chr>,
#> #   airs_day <chr>, airs_time <chr>, airs_timezone <chr>, trakt <chr>,
#> #   slug <chr>, tvdb <chr>, imdb <chr>, tmdb <chr>

# A season
comments_item("140265")
#> # A tibble: 1 × 12
#>   type   title       year trakt slug       tvdb  imdb  tmdb  season season_trakt
#>   <chr>  <chr>      <int> <chr> <chr>      <chr> <chr> <chr>  <int> <chr>       
#> 1 season Twin Peaks  1990 1907  twin-peaks 70533 tt00… 1920       3 138350      
#> # ℹ 2 more variables: season_tvdb <chr>, season_tmdb <chr>
comments_item("140265", extended = "full")
#> # A tibble: 1 × 48
#>   type   title   year tagline overview first_aired         runtime total_runtime
#>   <chr>  <chr>  <int> <chr>   <chr>    <dttm>                <int>         <int>
#> 1 season Twin …  1990 It is … The bod… 1990-04-08 00:00:00      42          2560
#> # ℹ 40 more variables: certification <chr>, country <chr>, status <chr>,
#> #   rating <dbl>, votes <int>, comment_count <int>, trailer <chr>,
#> #   homepage <chr>, network <chr>, updated_at <dttm>, language <chr>,
#> #   languages <list>, available_translations <list>, genres <list>,
#> #   subgenres <list>, aired_episodes <int>, original_title <chr>,
#> #   airs_day <chr>, airs_time <chr>, airs_timezone <chr>, trakt <chr>,
#> #   slug <chr>, tvdb <chr>, imdb <chr>, tmdb <chr>, season <int>, …

# An episode
comments_item("136632")
#> # A tibble: 1 × 15
#>   type    title  year trakt slug  tvdb  imdb  tmdb  season episode episode_title
#>   <chr>   <chr> <int> <chr> <chr> <chr> <chr> <chr>  <int>   <int> <chr>        
#> 1 episode Game…  2011 1390  game… 1213… tt09… 1399       7       4 The Spoils o…
#> # ℹ 4 more variables: episode_trakt <chr>, episode_tvdb <chr>,
#> #   episode_imdb <chr>, episode_tmdb <chr>
comments_item("136632", extended = "full")
#> # A tibble: 1 × 52
#>   type    title  year tagline overview first_aired         runtime total_runtime
#>   <chr>   <chr> <int> <chr>   <chr>    <dttm>                <int>         <int>
#> 1 episode Game…  2011 Winter… Seven n… 2011-04-18 01:00:00      55          4232
#> # ℹ 44 more variables: certification <chr>, country <chr>, status <chr>,
#> #   rating <dbl>, votes <int>, comment_count <int>, trailer <chr>,
#> #   homepage <chr>, network <chr>, updated_at <dttm>, language <chr>,
#> #   languages <list>, available_translations <list>, genres <list>,
#> #   subgenres <list>, aired_episodes <int>, original_title <chr>,
#> #   airs_day <chr>, airs_time <chr>, airs_timezone <chr>, trakt <chr>,
#> #   slug <chr>, tvdb <chr>, imdb <chr>, tmdb <chr>, season <int>, …
```
