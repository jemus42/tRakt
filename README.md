
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tRakt <img src="https://jemus42.github.io/tRakt/reference/figures/logo.png" align="right" height="120"/>

<!-- badges: start -->

[![Travis
(.org)](https://img.shields.io/travis/jemus42/tRakt.svg?logo=travis)](https://travis-ci.org/jemus42/tRakt)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/jemus42/tRakt?branch=master&svg=true)](https://ci.appveyor.com/project/jemus42/tRakt)
[![Coverage
status](https://codecov.io/gh/jemus42/tRakt/branch/master/graph/badge.svg)](https://codecov.io/github/jemus42/tRakt?branch=master)
<!-- [![CRAN status](https://www.r-pkg.org/badges/version/tRakt)](https://cran.r-project.org/package=tRakt) -->
[![GitHub
release](https://img.shields.io/github/release/jemus42/tRakt.svg?logo=GitHub)](https://github.com/jemus42/tRakt/releases)
[![GitHub last commit
(master)](https://img.shields.io/github/last-commit/jemus42/tRakt/master.svg?logo=GithUb)](https://github.com/jemus42/tRakt/commits/master)
<!-- badges: end -->

`tRakt` contains functions to retrieve data from
[trakt.tv](https://trakt.tv/), a site similiar to
[IMDb](https://imdb.com) with a broader focus, including TV shows and
more social features – and, most importantly, [a publicly available
API](https://trakt.docs.apiary.io).

It’s an [R](http://r-project.org) package primarily used by (i.e. built
for) [this webapp](http://trakt.jemu.name).  
Please note that while this package is *basically* an API-client, it is
a little more opinionated and might deliver results that do not exactly
match the data delivered by the API. The primary motivation for this
package is to retrieve data that is easily processable for data analysis
and display, which is why it tries hard to coerce most data into tabular
form instead of using nested lists, which is what the direct translation
of the API results would look like.

## Installation

Get it from GitHub:

``` r
if (!("remotes" %in% installed.packages())) {
  install.packages("remotes")
}
remotes::install_github("jemus42/tRakt")

library("tRakt")
```

## Usage

``` r
library(tibble) # for glimpse()
library(tRakt)

# Search for show, get basic info
show_info <- trakt.search("Utopia", type = "show")
glimpse(show_info)
#> Observations: 1
#> Variables: 9
#> $ type  <chr> "show"
#> $ score <dbl> 1000
#> $ title <chr> "Utopia"
#> $ year  <int> 2013
#> $ trakt <chr> "46241"
#> $ slug  <chr> "utopia"
#> $ tvdb  <chr> "264991"
#> $ imdb  <chr> "tt2384811"
#> $ tmdb  <chr> "46511"

# Get season information for the show using its trakt ID
trakt.seasons.summary(show_info$trakt, extended = "full")
#> # A tibble: 2 x 12
#>   season rating votes episode_count aired_episodes title overview
#>    <int>  <dbl> <int>         <int>          <int> <chr> <chr>   
#> 1      1   8.66   170             6              6 Seas… When a …
#> 2      2   8.22   122             6              6 Seas… It has …
#> # … with 5 more variables: first_aired <dttm>, network <chr>, trakt <chr>,
#> #   tvdb <chr>, tmdb <chr>

# Get episode data for both seasons
trakt.seasons.season(show_info$trakt, seasons = c(1, 2), extended = "full") %>%
  glimpse()
#> Observations: 12
#> Variables: 16
#> $ season                 <int> 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2
#> $ episode                <int> 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "E…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
#> $ overview               <chr> "When five strangers from an online comic…
#> $ rating                 <dbl> 8.24108, 8.12560, 8.14040, 8.10725, 8.306…
#> $ votes                  <int> 1037, 836, 755, 690, 659, 687, 694, 610, …
#> $ comment_count          <int> 3, 0, 1, 1, 1, 1, 1, 1, 0, 1, 2, 1
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00…
#> $ updated_at             <dttm> 2019-09-15 22:45:09, 2019-09-16 15:08:15…
#> $ available_translations <list> [<"bs", "de", "el", "en", "es", "fr", "h…
#> $ runtime                <int> 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 6…
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748…
#> $ imdb                   <chr> "tt2618234", "tt2618232", "tt2618236", "t…
#> $ tmdb                   <chr> "910003", "910004", "910005", "910006", "…
```

## Credentials

The API requires at least a `client id` for the API calls.  
Loading the package (or calling its functions via `tRakt::` wil
automatically set the app’s client id (see `?trakt_credentials()`) – for
extended use you should set your own credentials via enviroment
variables in your `.Renviron` like this:

``` sh
# tRakt
trakt_client_id=12fc1de7[...]3d629afdf2
trakt_username=jemus42
```

  - `trakt_client_id` **Required**. It’s used in the HTTP headers for
    the API calls, which is kind of a biggie.
  - `trakt_username` **Optional**. For functions that retrieve a user’s
    watched shows or stats (`trakt.user.*`), this just sets the default
    value so you don’t have to keep supplying it in individual function
    calls when you’re just looking at your own data anyway.

Please not that there’s no client secret listed – that’s because this
package doesn’t implement any authenticated methods. Maybe in the
future.

To get your credentials, [you have to have an (approved) app over at
trakt.tv](http://trakt.tv/oauth/applications).  
Don’t worry, it’s really easy to set up. Even I did it.

You theoretically never need to supply your own credentials. However, if
you want to actually use this package for some project, I do not
recommend relying on my credentials.  
That would make me a sad panda. As of now, the trakt.tv API does not
have any rate-limiting, but it’s not guaranteed to stay like this in the
future.

# Code of Conduct

Please note that the **tRakt** project is released with a [Contributor
Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this
project, you agree to abide by its terms.
