# Get a single person's details

Get a single person's details, like their various IDs. If `extended` is
`"full"`, there will also be biographical data if available, e.g. their
birthday.

## Usage

``` r
people_summary(id, extended = c("min", "full"))
```

## Source

`people_summary()` wraps endpoint
[/people/:id](https://trakt.docs.apiary.io/#reference/people/summary/get-a-single-person).

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

## See also

Other people data:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md)

Other summary methods:
[`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md),
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md)

## Examples

``` r
# A single person's extended information
people_summary("bryan-cranston", "full")
#> Error in recycle_columns(x, .rows, lengths): Tibble columns must have compatible sizes.
#> • Size 2: Column `images`.
#> • Size 4: Column `social_ids`.
#> ℹ Only values of size one are recycled.

# Multiple people
people_summary(c("kit-harington", "emilia-clarke"))
#> Error in purrr::map(input, fn, ...): ℹ In index: 1.
#> Caused by error in `recycle_columns()`:
#> ! Tibble columns must have compatible sizes.
#> • Size 2: Column `images`.
#> • Size 4: Column `social_ids`.
#> ℹ Only values of size one are recycled.
```
