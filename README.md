
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

`tRakt` helps you to retrieve data from [trakt.tv](https://trakt.tv/), a
site similiar to [IMDb](https://imdb.com) with a wider focus, yet
smaller user base. The site also enables media-center integration, so
you can automatically sync your collection and watch progress, as well
as scrobble playback and ratings via [Plex](https://www.plex.tv/),
[Kodi](https://kodi.tv/) and the likes.  
And, most importantly, [trakt.tv has a publicly available
API](https://trakt.docs.apiary.io) – which makes this package possible
and allows you to collect all that nice data people have contributed.

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
```

Search for a show, get basic info:

``` r
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
```

Get season information for the show using its trakt ID:

``` r
trakt.seasons.summary(show_info$trakt, extended = "full") %>%
  glimpse()
#> Observations: 2
#> Variables: 12
#> $ season         <int> 1, 2
#> $ rating         <dbl> 8.66471, 8.22131
#> $ votes          <int> 170, 122
#> $ episode_count  <int> 6, 6
#> $ aired_episodes <int> 6, 6
#> $ title          <chr> "Season 1", "Season 2"
#> $ overview       <chr> "When a group of strangers find themselves in pos…
#> $ first_aired    <dttm> 2013-01-15 21:00:00, 2014-07-14 20:00:00
#> $ network        <chr> "Channel 4", "Channel 4"
#> $ trakt          <chr> "56008", "56009"
#> $ tvdb           <chr> "507598", "524149"
#> $ tmdb           <chr> "54695", "54696"
```

Get episode data for the first season:

``` r
trakt.seasons.season(show_info$trakt, seasons = 1, extended = "full") %>%
  glimpse()
#> Observations: 6
#> Variables: 16
#> $ season                 <int> 1, 1, 1, 1, 1, 1
#> $ episode                <int> 1, 2, 3, 4, 5, 6
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "E…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6
#> $ overview               <chr> "When five strangers from an online comic…
#> $ rating                 <dbl> 8.23965, 8.12634, 8.14135, 8.11127, 8.304…
#> $ votes                  <int> 1039, 839, 757, 692, 661, 689
#> $ comment_count          <int> 3, 0, 1, 1, 1, 1
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00…
#> $ updated_at             <dttm> 2019-09-29 19:38:55, 2019-09-30 05:39:10…
#> $ available_translations <list> [<"bs", "de", "el", "en", "es", "fr", "h…
#> $ runtime                <int> 60, 60, 60, 60, 60, 60
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748…
#> $ imdb                   <chr> "tt2618234", "tt2618232", "tt2618236", "t…
#> $ tmdb                   <chr> "910003", "910004", "910005", "910006", "…
```

Or alternatively, get the [trending
shows](https://trakt.tv/shows/trending):

``` r
trakt.trending("shows")
#> # A tibble: 10 x 8
#>    watchers title            year trakt  slug            tvdb  imdb   tmdb 
#>       <int> <chr>           <int> <chr>  <chr>           <chr> <chr>  <chr>
#>  1       50 Fear the Walki…  2015 94961  fear-the-walki… 2908… tt374… 62286
#>  2       49 Power            2014 54306  power           2765… tt328… 54650
#>  3       48 The Rookie       2018 134421 the-rookie-2018 3506… tt758… 79744
#>  4       42 NCIS: Los Ange…  2009 17532  ncis-los-angel… 95441 tt137… 17610
#>  5       36 Last Week Toni…  2014 60267  last-week-toni… 2785… tt353… 60694
#>  6       34 Preacher         2016 102034 preacher        3004… tt501… 64230
#>  7       33 Ballers          2015 78111  ballers         2817… tt289… 62704
#>  8       29 Suits            2011 37522  suits           2478… tt163… 37680
#>  9       28 The Big Bang T…  2007 1409   the-big-bang-t… 80379 tt089… 1418 
#> 10       28 God Friended Me  2018 133611 god-friended-me 3496… tt794… 81114
```

Maybe you want to know how long it would take you to binge through these
shows:

``` r
library(dplyr)
library(hms)
library(glue)

trakt.trending("shows", extended = "full") %>%
  transmute(
    show = glue("{title} ({year})"),
    runtime_hms = hms(minutes = runtime),
    aired_episodes = aired_episodes,
    runtime_aired = hms(minutes = runtime * aired_episodes)
  ) %>%
  knitr::kable(
    col.names = c("Show", "Episode Runtime", "Aired Episodes", "Total Runtime (aired)")
  )
```

| Show                                      | Episode Runtime | Aired Episodes | Total Runtime (aired) |
| :---------------------------------------- | :-------------- | -------------: | :-------------------- |
| Fear the Walking Dead (2015)              | 00:45:00        |             69 | 51:45:00              |
| Power (2014)                              | 01:00:00        |             54 | 54:00:00              |
| The Rookie (2018)                         | 00:43:00        |             21 | 15:03:00              |
| NCIS: Los Angeles (2009)                  | 00:45:00        |            241 | 180:45:00             |
| Last Week Tonight with John Oliver (2014) | 00:30:00        |            173 | 86:30:00              |
| Preacher (2016)                           | 00:45:00        |             43 | 32:15:00              |
| Ballers (2015)                            | 00:30:00        |             45 | 22:30:00              |
| Suits (2011)                              | 00:45:00        |            134 | 100:30:00             |
| The Big Bang Theory (2007)                | 00:22:00        |            279 | 102:18:00             |
| God Friended Me (2018)                    | 00:45:00        |             21 | 15:45:00              |

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
