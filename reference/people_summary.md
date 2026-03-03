# Get a single person's details

Get a single person's details, like their various IDs. If `extended` is
`"full"`, there will also be biographical data if available, e.g. their
birthday.

## Usage

``` r
people_summary(id, extended = "min")
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
#> # A tibble: 1 × 18
#>   name           death gender height birthday   homepage biography    birthplace
#>   <chr>          <chr> <chr>   <dbl> <date>     <chr>    <chr>        <chr>     
#> 1 Bryan Cranston NA    male     179. 1956-03-07 NA       "Bryan Lee … Hollywood…
#> # ℹ 10 more variables: updated_at <dttm>, known_for_department <chr>,
#> #   imdb <chr>, slug <chr>, tmdb <chr>, trakt <chr>, social_twitter <chr>,
#> #   social_facebook <chr>, social_instagram <chr>, social_wikipedia <chr>

# Multiple people
people_summary(c("kit-harington", "emilia-clarke"))
#> # A tibble: 2 × 18
#>   name          death gender height birthday   homepage biography     birthplace
#>   <chr>         <chr> <chr>   <int> <date>     <chr>    <chr>         <chr>     
#> 1 Kit Harington NA    male      173 1986-12-26 NA       "Christopher… Worcester…
#> 2 Emilia Clarke NA    female    157 1986-10-23 NA       "Emilia Isob… London, E…
#> # ℹ 10 more variables: updated_at <dttm>, known_for_department <chr>,
#> #   imdb <chr>, slug <chr>, tmdb <chr>, trakt <chr>, social_twitter <chr>,
#> #   social_facebook <chr>, social_instagram <chr>, social_wikipedia <chr>
```
