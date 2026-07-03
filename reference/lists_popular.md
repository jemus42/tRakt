# Get popular / trending lists

Get popular / trending lists

## Usage

``` r
lists_popular(limit = 10, type = c("personal", "official"))

lists_trending(limit = 10, type = c("personal", "official"))
```

## Source

`lists_popular()` wraps endpoint
[/lists/popular/:type](https://trakt.docs.apiary.io/#reference/lists/popular/get-popular-lists).

`lists_trending()` wraps endpoint
[/lists/trending/:type](https://trakt.docs.apiary.io/#reference/lists/trending/get-trending-lists).

## Arguments

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

- type:

  `character(1) ["personal"]`: The kind of lists to return, one of
  `"personal"` (user-created lists) or `"official"` (Trakt-curated
  lists). The trakt.tv API requires this path segment; a request without
  it returns an empty (HTTP 204) response.

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
[`filters`](https://jemus42.github.io/tRakt/reference/filters.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

## Examples

``` r
lists_popular()
#> # A tibble: 10 × 32
#>    name      description privacy share_link type  display_numbers allow_comments
#>    <chr>     <chr>       <chr>   <chr>      <chr> <lgl>           <lgl>         
#>  1 IMDB: To… "Top 250 m… public  ""         pers… TRUE            TRUE          
#>  2 MARVEL C… "**UPDATED… public  ""         pers… TRUE            TRUE          
#>  3 IMDB: To… "Top 250 T… public  ""         pers… TRUE            TRUE          
#>  4 Best Min… "What’s a … public  ""         pers… FALSE           TRUE          
#>  5 1001 Gre… "/u/StopRe… public  ""         pers… TRUE            TRUE          
#>  6 1001 Mov… "> 1001 Mo… public  ""         pers… TRUE            TRUE          
#>  7 Mindfuck  "The objec… public  ""         pers… FALSE           TRUE          
#>  8 Great Mo… "Every yea… public  ""         pers… FALSE           TRUE          
#>  9 True Cri… "This isn'… public  ""         pers… FALSE           TRUE          
#> 10 DC Unive… ""          public  ""         pers… TRUE            TRUE          
#> # ℹ 25 more variables: sort_by <chr>, sort_how <chr>, created_at <dttm>,
#> #   updated_at <dttm>, item_count <int>, comment_count <int>, likes <int>,
#> #   slug <chr>, trakt <chr>, username <chr>, private <lgl>, deleted <lgl>,
#> #   joined_at <dttm>, location <chr>, about <chr>, user_name <chr>,
#> #   gender <chr>, age <int>, vip <lgl>, vip_ep <lgl>, vip_cover_image <lgl>,
#> #   director <lgl>, user_slug <chr>, user_trakt <int>, avatar <chr>
lists_trending()
#> # A tibble: 10 × 32
#>    name      description privacy share_link type  display_numbers allow_comments
#>    <chr>     <chr>       <chr>   <chr>      <chr> <lgl>           <lgl>         
#>  1 IMDB: To… "Top 250 m… public  ""         pers… TRUE            TRUE          
#>  2 IMDB: To… "Top 250 T… public  ""         pers… TRUE            TRUE          
#>  3 Best Min… "What’s a … public  ""         pers… FALSE           TRUE          
#>  4 MARVEL C… "**UPDATED… public  ""         pers… TRUE            TRUE          
#>  5 Trakt: P… "The Trakt… public  ""         pers… TRUE            TRUE          
#>  6 1001 Gre… "/u/StopRe… public  ""         pers… TRUE            TRUE          
#>  7 Sci-Fi    ""          public  ""         pers… FALSE           TRUE          
#>  8 True Cri… "This isn'… public  ""         pers… FALSE           TRUE          
#>  9 Popular … "This isn'… public  ""         pers… FALSE           TRUE          
#> 10 Studio G… "Animated … public  ""         pers… TRUE            TRUE          
#> # ℹ 25 more variables: sort_by <chr>, sort_how <chr>, created_at <dttm>,
#> #   updated_at <dttm>, item_count <int>, comment_count <int>, likes <int>,
#> #   slug <chr>, trakt <chr>, username <chr>, private <lgl>, deleted <lgl>,
#> #   joined_at <dttm>, location <chr>, about <chr>, user_name <chr>,
#> #   gender <chr>, age <int>, vip <lgl>, vip_ep <lgl>, vip_cover_image <lgl>,
#> #   director <lgl>, user_slug <chr>, user_trakt <int>, avatar <chr>
```
