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
#> # A tibble: 2 × 17
#>   liked_at username private deleted joined_at           location about user_name
#>   <chr>    <chr>    <lgl>   <lgl>   <dttm>              <chr>    <chr> <chr>    
#> 1 2019-06… Khawlah  FALSE   FALSE   2014-12-22 16:58:37 "Saudi … ""    Khawlah  
#> 2 2019-09… OvejaMe… FALSE   FALSE   2013-06-29 02:23:22 ""       ""    Laura    
#> # ℹ 9 more variables: gender <chr>, age <int>, vip <lgl>, vip_ep <lgl>,
#> #   vip_cover_image <lgl>, director <lgl>, user_slug <chr>, user_trakt <int>,
#> #   avatar <chr>
# A movie
comments_item("236397")
#> # A tibble: 1 × 9
#>   type   year title                  imdb  slug  tmdb  trakt plex_guid plex_slug
#>   <chr> <int> <chr>                  <chr> <chr> <chr> <chr> <chr>     <chr>    
#> 1 movie  2019 John Wick: Chapter 3 … tt61… john… 4581… 3042… 5d776d31… john-wic…
comments_item("236397", extended = "full")
#> # A tibble: 1 × 30
#>   type   year title   votes genres rating status country runtime tagline trailer
#>   <chr> <int> <chr>   <int> <list>  <dbl> <chr>  <chr>     <int> <chr>   <chr>  
#> 1 movie  2019 John W… 33215 <chr>    7.81 relea… us          131 If you… https:…
#> # ℹ 19 more variables: homepage <chr>, language <chr>, overview <chr>,
#> #   released <date>, languages <list>, subgenres <list>, updated_at <dttm>,
#> #   after_credits <lgl>, certification <chr>, comment_count <int>,
#> #   during_credits <lgl>, original_title <chr>, available_translations <list>,
#> #   imdb <chr>, slug <chr>, tmdb <chr>, trakt <chr>, plex_guid <chr>,
#> #   plex_slug <chr>

# A show
comments_item("120768")
#> # A tibble: 1 × 11
#>   type   year title       aired_episodes imdb  slug  tmdb  tvdb  trakt plex_guid
#>   <chr> <int> <chr>                <int> <chr> <chr> <chr> <chr> <chr> <chr>    
#> 1 show   2017 13 Reasons…             49 tt18… 13-r… 66788 3231… 1161… 5d9c07fc…
#> # ℹ 1 more variable: plex_slug <chr>
comments_item("120768", extended = "full")
#> # A tibble: 1 × 36
#>   type   year title   votes genres rating status country network runtime tagline
#>   <chr> <int> <chr>   <int> <list>  <dbl> <chr>  <chr>   <chr>     <int> <chr>  
#> 1 show   2017 13 Rea… 12499 <chr>    6.99 ended  us      Netflix      60 If you…
#> # ℹ 25 more variables: trailer <chr>, homepage <chr>, language <chr>,
#> #   overview <chr>, languages <list>, subgenres <list>, last_aired <chr>,
#> #   updated_at <dttm>, first_aired <dttm>, certification <chr>,
#> #   comment_count <int>, total_runtime <int>, aired_episodes <int>,
#> #   original_title <chr>, available_translations <list>, airs_day <chr>,
#> #   airs_time <chr>, airs_timezone <chr>, imdb <chr>, slug <chr>, tmdb <chr>,
#> #   tvdb <chr>, trakt <chr>, plex_guid <chr>, plex_slug <chr>

# A season
comments_item("140265")
#> # A tibble: 1 × 16
#>   type    year title      aired_episodes imdb  slug  tmdb  tvdb  trakt plex_guid
#>   <chr>  <int> <chr>               <int> <chr> <chr> <chr> <chr> <chr> <chr>    
#> 1 season  1990 Twin Peaks             48 tt00… twin… 1920  70533 1907  5d9c0871…
#> # ℹ 6 more variables: plex_slug <chr>, season <int>, season_tmdb <chr>,
#> #   season_tvdb <chr>, season_trakt <chr>, season_plex_guid <chr>
comments_item("140265", extended = "full")
#> # A tibble: 1 × 52
#>   type    year title  votes genres rating status country network runtime tagline
#>   <chr>  <int> <chr>  <int> <list>  <dbl> <chr>  <chr>   <chr>   <chr>   <chr>  
#> 1 season  1990 Twin …  7107 <chr>    8.42 ended  us      Showti… NA      It is …
#> # ℹ 41 more variables: trailer <chr>, homepage <chr>, language <chr>,
#> #   overview <chr>, languages <list>, subgenres <list>, last_aired <chr>,
#> #   updated_at <dttm>, first_aired <dttm>, certification <chr>,
#> #   comment_count <int>, total_runtime <int>, aired_episodes <int>,
#> #   original_title <chr>, available_translations <list>, airs_day <chr>,
#> #   airs_time <chr>, airs_timezone <chr>, imdb <chr>, slug <chr>, tmdb <chr>,
#> #   tvdb <chr>, trakt <chr>, plex_guid <chr>, plex_slug <chr>, …

# An episode
comments_item("136632")
#> # A tibble: 1 × 19
#>   type     year title     aired_episodes imdb  slug  tmdb  tvdb  trakt plex_guid
#>   <chr>   <int> <chr>              <int> <chr> <chr> <chr> <chr> <chr> <chr>    
#> 1 episode  2011 Game of …             73 tt09… game… 1399  1213… 1390  5d9c086c…
#> # ℹ 9 more variables: plex_slug <chr>, episode_title <chr>, episode <int>,
#> #   season <int>, episode_imdb <chr>, episode_tmdb <chr>, episode_tvdb <chr>,
#> #   episode_trakt <chr>, episode_plex_guid <chr>
comments_item("136632", extended = "full")
#> # A tibble: 1 × 58
#>   type     year title votes genres rating status country network runtime tagline
#>   <chr>   <int> <chr> <int> <list>  <dbl> <chr>  <chr>   <chr>     <int> <chr>  
#> 1 episode  2011 Game… 73948 <chr>    8.92 ended  us      HBO          55 Winter…
#> # ℹ 47 more variables: trailer <chr>, homepage <chr>, language <chr>,
#> #   overview <chr>, languages <list>, subgenres <list>, last_aired <chr>,
#> #   updated_at <dttm>, first_aired <dttm>, certification <chr>,
#> #   comment_count <int>, total_runtime <int>, aired_episodes <int>,
#> #   original_title <chr>, available_translations <list>, airs_day <chr>,
#> #   airs_time <chr>, airs_timezone <chr>, imdb <chr>, slug <chr>, tmdb <chr>,
#> #   tvdb <chr>, trakt <chr>, plex_guid <chr>, plex_slug <chr>, …
```
