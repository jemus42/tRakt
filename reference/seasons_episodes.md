# Get a season of a show

Similar to
[seasons_summary](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
but this function returns full data for a single season, i.e. all the
episodes of the season

## Usage

``` r
seasons_episodes(id, seasons = 1L, extended = "min")
```

## Source

`seasons_episodes()` wraps endpoint
[/shows/:id/seasons/:season?translations=](https://trakt.docs.apiary.io/#reference/seasons/episodes/get-all-episodes-for-a-single-season).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- seasons:

  `integer(1) [1L]`: The season(s) to get. Use `0` for specials.

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

## Note

If you want to quickly gather episode data of all available seasons, see
[seasons_summary](https://jemus42.github.io/tRakt/reference/seasons_summary.md)
and use the `episodes = TRUE` parameter.

## See also

Other season data:
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

## Examples

``` r
seasons_episodes("breaking-bad", 1)
#> # A tibble: 7 × 8
#>   title                         episode season imdb  tmdb  tvdb  trakt plex_guid
#>   <chr>                           <int>  <int> <chr> <chr> <chr> <chr> <chr>    
#> 1 Pilot                               1      1 tt09… 62085 3492… 73482 5d9c0fc3…
#> 2 Cat's in the Bag...                 2      1 tt10… 62086 3492… 73483 5d9c0fc3…
#> 3 ...And the Bag's in the River       3      1 tt10… 62087 3492… 73484 5d9c0fc3…
#> 4 Cancer Man                          4      1 tt10… 62088 3492… 73485 5d9c0fc3…
#> 5 Gray Matter                         5      1 tt10… 62089 3492… 73486 5d9c0fc3…
#> 6 Crazy Handful of Nothin'            6      1 tt10… 62090 3551… 73487 5d9c0fc3…
#> 7 A No Rough Stuff Type Deal          7      1 tt10… 62091 3525… 73488 5d9c0fc3…

# Including all episode data:
seasons_episodes("breaking-bad", 1, extended = "full")
#> # A tibble: 7 × 23
#>   title      votes episode rating season runtime overview released   episode_abs
#>   <chr>      <int>   <int>  <dbl>  <int>   <int> <chr>    <date>           <int>
#> 1 Pilot       4758       1   8.35      1      59 When an… 2008-01-21           1
#> 2 Cat's in …  3951       2   8.11      1      49 Walt an… 2008-01-28           2
#> 3 ...And th…  3678       3   8.04      1      49 Walter … 2008-02-11           3
#> 4 Cancer Man  3543       4   7.93      1      49 Walter … 2008-02-18           4
#> 5 Gray Matt…  3469       5   7.95      1      49 Walter … 2008-02-25           5
#> 6 Crazy Han…  3503       6   8.54      1      49 The sid… 2008-03-03           6
#> 7 A No Roug…  3410       7   8.35      1      48 Walter … 2008-03-10           7
#> # ℹ 14 more variables: updated_at <dttm>, first_aired <dttm>,
#> #   episode_type <chr>, after_credits <lgl>, comment_count <int>,
#> #   during_credits <lgl>, original_title <chr>, available_translations <list>,
#> #   effective_release_date <chr>, imdb <chr>, tmdb <chr>, tvdb <chr>,
#> #   trakt <chr>, plex_guid <chr>
```
