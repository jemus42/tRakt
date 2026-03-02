# Easy episode number padding

Simple function to ease the creation of `sXXeYY` episode ids. Note that
`s` and `e` must have the same length.

## Usage

``` r
pad_episode(s = "0", e = "0", s_width = 2, e_width = 2)
```

## Arguments

- s:

  Input season number, coerced to `character`.

- e:

  Input episode number, coerced to `character`.

- s_width:

  The length of the season number padding. Defaults to 2.

- e_width:

  The length of the episode number padding. Defaults to 2.

## Value

A `character` in the common `sXXeYY` format

## Note

I like my sXXeYY format, okay?

## See also

Other utility functions:
[`build_trakt_url()`](https://jemus42.github.io/tRakt/reference/build_trakt_url.md)

## Examples

``` r
# Season 2, episode 4
pad_episode(2, 4)
#> [1] "s02e04"
pad_episode(1, 85, e_width = 3)
#> [1] "s01e085"
```
