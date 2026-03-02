# Get a season of a show

Similar to
[seasons_summary](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
but this function returns only metadata for a season.

## Usage

``` r
seasons_season(id, seasons = 1L, extended = c("min", "full"))
```

## Source

`seasons_season()` wraps endpoint
[/shows/:id/seasons/:season/info](https://trakt.docs.apiary.io/#reference/seasons/season/get-single-seasons-for-a-show).

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

  `character(1)`: Either `"min"` (API default) or `"full"`. The latter
  returns more variables and should generally only be used if required.
  See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

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
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seasons_season("breaking-bad", 1)

# Including all episode data:
seasons_season("breaking-bad", 1, extended = "full")
} # }
```
