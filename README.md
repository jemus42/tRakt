
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tRakt

[![Travis build
status](https://travis-ci.org/jemus42/tRakt.svg?branch=master)](https://travis-ci.org/jemus42/tRakt)
[![Coverage
status](https://codecov.io/gh/jemus42/tRakt/branch/master/graph/badge.svg)](https://codecov.io/github/jemus42/tRakt?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/tRakt)](https://cran.r-project.org/package=tRakt)

This is `tRakt` version `0.14.9000`.  
It contains functions to retrieve data from
[trakt.tv](http://trakt.tv/), a site similiar to [IMDb](http://imdb.com)
with a broader focus including TV shows and more social features – and,
most importantly, a publicly available API.

It’s an [R package](http://r-project.org) primarily used by (i.e. built
for) [this webapp](http://trakt.jemu.name), but you can fiddle around
with it if you like.  
Please note that while this package *basically* is an API-client, it is
a little more opinionated and might deliver results that don not exactly
match the data delivered by the API. The primary motivation for this
package is to retrieve data that is easily processable for data analysis
and display, which is why it tries hard to coerce most data into tabular
form instead of using, for example, nested lists.

## Installation

Get it from GitHub:

``` r
if (!require("remotes")) install.packages("remotes")
remotes::install_github("jemus42/tRakt")
library("tRakt")
```

## Basic usage

``` r
library(dplyr)
library(tRakt)

# Search for show, get basic info
show_info <- trakt.search("Utopia", type = "show")
glimpse(show_info)
#> Observations: 1
#> Variables: 10
#> $ title    <chr> "Utopia"
#> $ overview <chr> "The story follows a small group of people who find the…
#> $ year     <int> 2013
#> $ status   <chr> "ended"
#> $ trakt    <int> 46241
#> $ slug     <chr> "utopia"
#> $ tvdb     <int> 264991
#> $ imdb     <chr> "tt2384811"
#> $ tmdb     <int> 46511
#> $ tvrage   <int> NA

# Get season information for the show
show_seasons <- trakt.seasons.summary(show_info$trakt)

knitr::kable(show_seasons)
```

| season | trakt |   tvdb |  tmdb | tvrage |
| -----: | ----: | -----: | ----: | :----- |
|      1 | 56008 | 507598 | 54695 | NA     |
|      2 | 56009 | 524149 | 54696 | NA     |

``` r

# Get episode data
show_episodes <- trakt.seasons.season(show_info$trakt, 
                                      seasons = c(1, 2), extended = "full")

show_episodes %>%
  select(season, episode, title, rating, votes, first_aired) %>%
  knitr::kable()
```

| season | episode | title     |  rating | votes | first\_aired        |
| -----: | ------: | :-------- | ------: | ----: | :------------------ |
|      1 |       1 | Episode 1 | 8.25247 |  1010 | 2013-01-15 21:00:00 |
|      1 |       2 | Episode 2 | 8.13653 |   813 | 2013-01-22 21:00:00 |
|      1 |       3 | Episode 3 | 8.15875 |   737 | 2013-01-29 21:00:00 |
|      1 |       4 | Episode 4 | 8.11078 |   677 | 2013-02-05 21:00:00 |
|      1 |       5 | Episode 5 | 8.32504 |   643 | 2013-02-12 21:00:00 |
|      1 |       6 | Episode 6 | 8.71620 |   673 | 2013-02-19 21:00:00 |
|      2 |       1 | Episode 1 | 8.57016 |   677 | 2014-07-14 20:00:00 |
|      2 |       2 | Episode 2 | 8.35738 |   596 | 2014-07-15 20:00:00 |
|      2 |       3 | Episode 3 | 8.28975 |   566 | 2014-07-22 20:00:00 |
|      2 |       4 | Episode 4 | 8.26964 |   560 | 2014-07-29 20:00:00 |
|      2 |       5 | Episode 5 | 8.30287 |   558 | 2014-08-05 20:00:00 |
|      2 |       6 | Episode 6 | 8.28253 |   538 | 2014-08-12 20:00:00 |

## Setting credentials

The APIv2 requires at least a `client id` for the API calls.  
Calling `get_trakt_credentials()` will set everything up for you, but
you either have to manually plug your values in (see
`?get_trakt_credentials()`), or have the values supplied via enviroment
variables in your `.Renviron` like this:

``` sh
# tRakt
trakt_username=jemus42
trakt_client_id=12fc1de7[...]3d629afdf2
```

  - `trakt_username` Optional. For functions that pull a user’s watched
    shows or stats (`trakt.user.*`)
  - `trakt_client_id` Required. It’s used in the HTTP headers for the
    API calls, which is kind of a biggie.

To get your credentials, [you have to have an (approved) app over at
trakt.tv](http://trakt.tv/oauth/applications).  
Don’t worry, it’s really easy to set up. Even I did it.

### Use my app’s client.id as a fallback

As a convenience for you, and also to make automated testing a little
easier, `get_trakt_credentials()` automatically sets my `client.id` as a
fallback, so you theoretically never need to supply your own
credentials. However, if you want to actually use this package for some
project, I do not recommend relying on my credentials. That would make
me a sad panda.

# Code of Conduct

Please note that the **tRakt** project is released with a [Contributor
Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this
project, you agree to abide by its terms.
