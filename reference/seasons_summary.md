# Get a show's seasons

Get details for a show's seasons, e.g. how many seasons there are and
how many epsiodes each season has. With `episodes == TRUE` and
`extended == "full"`, this function is also suitable to retrieve all
episode data for all seasons of a show with just a single API call.

## Usage

``` r
seasons_summary(
  id,
  episodes = FALSE,
  drop_specials = TRUE,
  drop_unaired = TRUE,
  extended = "min"
)
```

## Source

`seasons_summary()` wraps endpoint
[/shows/:id/seasons/:season](https://trakt.docs.apiary.io/#reference/seasons/summary/get-all-seasons-for-a-show).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- episodes:

  `logical(1) [FALSE]`: If `TRUE`, all episodes for each season are
  appended as a list-column, with the amount of variables depending on
  `extended`.

- drop_specials:

  `logical(1) [TRUE]`: Special episodes (season 0) are dropped

- drop_unaired:

  `logical(1) [TRUE]`: Seasons without aired episodes are dropped. Only
  works if `extended` is `"full"`.

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

## See also

Other season data:
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

Other summary methods:
[`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md),
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md)

## Examples

``` r
# Get just the season numbers and their IDs
seasons_summary("breaking-bad", extended = "min")
#> # A tibble: 5 × 5
#>   season tmdb  tvdb   trakt plex_guid               
#>    <int> <chr> <chr>  <chr> <chr>                   
#> 1      1 3572  30272  3950  602e61de66dfdb002c096b16
#> 2      2 3573  40719  3951  602e61df66dfdb002c096b48
#> 3      3 3575  171641 3952  602e61e266dfdb002c096ba3
#> 4      4 3576  297361 3953  602e61e266dfdb002c096bd2
#> 5      5 3578  490110 3954  602e61e366dfdb002c096c00
if (FALSE) { # \dontrun{
# Get season numbers, ratings, votes, titles and other metadata as well as
# a list-column containing all episode data
seasons_summary("utopia", extended = "full", episodes = TRUE)
} # }
```
