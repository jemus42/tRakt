# Get lists containing a movie, show, season, episode or person

Get lists containing a movie, show, season, episode or person

## Usage

``` r
movies_lists(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = "min"
)

shows_lists(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = "min"
)

seasons_lists(
  id,
  season,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = "min"
)

episodes_lists(
  id,
  season,
  episode,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = "min"
)

people_lists(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = "min"
)
```

## Source

`movies_lists()` wraps endpoint
[/movies/:id/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/movies/lists/get-lists-containing-this-movie).

`shows_lists()` wraps endpoint
[/shows/:id/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/shows/lists/get-lists-containing-this-show).

`seasons_lists()` wraps endpoint
[/shows/:id/seasons/:season/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/seasons/lists/get-lists-containing-this-season).

`episodes_lists()` wraps endpoint
[/shows/:id/seasons/:season/episodes/:episode/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/episodes/lists/get-lists-containing-this-episode).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- type:

  `character(1) ["all"]`: The type of list, one of "all", "personal",
  "official" or "watchlists".

- sort:

  `character(1) ["popular"]`: Sort lists by one of "popular", "likes",
  "comments", "items", "added" or "updated".

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

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

- season, episode:

  `integer(1) [1L]`: The season and episode number. If longer, e.g.
  `1:5`, the function is vectorized and the output will be combined.
  This may result in *a lot* of API calls. Use wisely.

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## Functions

- `movies_lists()`: Lists containing a movie.

- `shows_lists()`: Lists containing a show.

- `seasons_lists()`: Lists containing a season.

- `episodes_lists()`: Lists containing an episode.

- `people_lists()`: Lists containing a person.

## See also

Other list methods:
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

Other movie data:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`movies_boxoffice()`](https://jemus42.github.io/tRakt/reference/movies_boxoffice.md),
[`movies_related()`](https://jemus42.github.io/tRakt/reference/movies_related.md),
[`movies_releases()`](https://jemus42.github.io/tRakt/reference/movies_releases.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other show data:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md),
[`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md)

Other season data:
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

Other people data:
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)

## Examples

``` r
movies_lists("190430", type = "personal", limit = 5)
#> # A tibble: 5 × 32
#>   name       description privacy share_link type  display_numbers allow_comments
#>   <chr>      <chr>       <chr>   <chr>      <chr> <lgl>           <lgl>         
#> 1 Sci-Fi     ""          public  ""         pers… FALSE           TRUE          
#> 2 Cult Clas… "Dive into… public  ""         pers… FALSE           TRUE          
#> 3 Watching … "This is a… public  ""         pers… FALSE           FALSE         
#> 4 Trakt: Po… "The Trakt… public  ""         pers… TRUE            TRUE          
#> 5 Comedy ac… ""          public  ""         pers… TRUE            TRUE          
#> # ℹ 25 more variables: sort_by <chr>, sort_how <chr>, created_at <dttm>,
#> #   updated_at <dttm>, item_count <int>, comment_count <int>, likes <int>,
#> #   slug <chr>, trakt <chr>, username <chr>, private <lgl>, deleted <lgl>,
#> #   joined_at <dttm>, location <chr>, about <chr>, user_name <chr>,
#> #   gender <chr>, age <int>, vip <lgl>, vip_ep <lgl>, vip_cover_image <lgl>,
#> #   director <lgl>, user_slug <chr>, user_trakt <int>, avatar <chr>
shows_lists("46241")
#> # A tibble: 10 × 32
#>    name      description privacy share_link type  display_numbers allow_comments
#>    <chr>     <chr>       <chr>   <chr>      <chr> <lgl>           <lgl>         
#>  1 Highly r… "Shows wit… public  ""         pers… FALSE           TRUE          
#>  2 Hidden G… ""          public  ""         pers… FALSE           TRUE          
#>  3 UK and I… ""          public  ""         pers… FALSE           TRUE          
#>  4 BBC Cult… "\"BBC Cul… public  ""         pers… TRUE            TRUE          
#>  5 TV Shows… "A collect… public  ""         pers… FALSE           TRUE          
#>  6 Obscure … ""          public  ""         pers… FALSE           FALSE         
#>  7 British … ""          public  ""         pers… FALSE           FALSE         
#>  8 The Guar… "https://w… public  ""         pers… TRUE            TRUE          
#>  9 BBC       ""          public  ""         pers… FALSE           FALSE         
#> 10 BritBox   ""          public  ""         pers… FALSE           FALSE         
#> # ℹ 25 more variables: sort_by <chr>, sort_how <chr>, created_at <dttm>,
#> #   updated_at <dttm>, item_count <int>, comment_count <int>, likes <int>,
#> #   slug <chr>, trakt <chr>, username <chr>, private <lgl>, deleted <lgl>,
#> #   joined_at <dttm>, location <chr>, about <chr>, user_name <chr>,
#> #   gender <chr>, age <int>, vip <lgl>, vip_ep <lgl>, vip_cover_image <lgl>,
#> #   director <lgl>, user_slug <chr>, user_trakt <int>, avatar <chr>
seasons_lists("46241", season = 1)
#> # A tibble: 10 × 24
#>    name      description privacy share_link type  display_numbers allow_comments
#>    <chr>     <chr>       <chr>   <chr>      <chr> <lgl>           <lgl>         
#>  1 Shows I … ""          public  https://t… pers… FALSE           TRUE          
#>  2 OMG! YOU… "My list o… public  https://t… pers… FALSE           TRUE          
#>  3 TV shows… ""          public  https://t… pers… TRUE            TRUE          
#>  4 Yo        ""          public  https://t… pers… TRUE            TRUE          
#>  5 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  6 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  7 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  8 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  9 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#> 10 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#> # ℹ 17 more variables: sort_by <chr>, sort_how <chr>, created_at <dttm>,
#> #   updated_at <dttm>, item_count <int>, comment_count <int>, likes <int>,
#> #   trakt <chr>, slug <chr>, username <chr>, private <lgl>, deleted <lgl>,
#> #   user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>, user_slug <chr>
episodes_lists("46241", season = 1, episode = 1)
#> # A tibble: 10 × 24
#>    name      description privacy share_link type  display_numbers allow_comments
#>    <chr>     <chr>       <chr>   <chr>      <chr> <lgl>           <lgl>         
#>  1 Watchlis… ""          public  https://t… pers… TRUE            TRUE          
#>  2 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  3 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  4 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  5 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  6 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  7 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  8 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#>  9 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#> 10 Watchlist "Movies, s… public  https://t… watc… FALSE           FALSE         
#> # ℹ 17 more variables: sort_by <chr>, sort_how <chr>, created_at <dttm>,
#> #   updated_at <dttm>, item_count <int>, comment_count <int>, likes <int>,
#> #   trakt <chr>, slug <chr>, username <chr>, private <lgl>, deleted <lgl>,
#> #   user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>, user_slug <chr>
people_lists("david-tennant")
#> # A tibble: 1 × 32
#>   name   description privacy share_link type     display_numbers allow_comments
#>   <chr>  <chr>       <chr>   <chr>      <chr>    <lgl>           <lgl>         
#> 1 Actors ""          public  ""         personal TRUE            TRUE          
#> # ℹ 25 more variables: sort_by <chr>, sort_how <chr>, created_at <dttm>,
#> #   updated_at <dttm>, item_count <int>, comment_count <int>, likes <int>,
#> #   slug <chr>, trakt <chr>, username <chr>, private <lgl>, deleted <lgl>,
#> #   joined_at <dttm>, location <chr>, about <chr>, user_name <chr>,
#> #   gender <chr>, age <int>, vip <lgl>, vip_ep <lgl>, vip_cover_image <lgl>,
#> #   director <lgl>, user_slug <chr>, user_trakt <int>, avatar <chr>

people_lists("emilia-clarke", sort = "items")
#> # A tibble: 2 × 32
#>   name       description privacy share_link type  display_numbers allow_comments
#>   <chr>      <chr>       <chr>   <chr>      <chr> <lgl>           <lgl>         
#> 1 Nude Actr… English la… public  ""         pers… TRUE            TRUE          
#> 2 Favourite… My persona… public  ""         pers… TRUE            TRUE          
#> # ℹ 25 more variables: sort_by <chr>, sort_how <chr>, created_at <dttm>,
#> #   updated_at <dttm>, item_count <int>, comment_count <int>, likes <int>,
#> #   slug <chr>, trakt <chr>, username <chr>, private <lgl>, deleted <lgl>,
#> #   joined_at <dttm>, location <chr>, about <chr>, user_name <chr>,
#> #   gender <chr>, age <int>, vip <lgl>, vip_ep <lgl>, vip_cover_image <lgl>,
#> #   director <lgl>, user_slug <chr>, user_trakt <int>, avatar <chr>
```
