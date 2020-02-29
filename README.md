
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
[![R build
status](https://github.com/jemus42/tRakt/workflows/R-CMD-check/badge.svg)](https://github.com/jemus42/tRakt/actions)
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
show_info <- search_query("Utopia", type = "show")
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
seasons_summary(show_info$trakt, extended = "full") %>%
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
seasons_season(show_info$trakt, seasons = 1, extended = "full") %>%
  glimpse()
#> Observations: 6
#> Variables: 16
#> $ season                 <int> 1, 1, 1, 1, 1, 1
#> $ episode                <int> 1, 2, 3, 4, 5, 6
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "E…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6
#> $ overview               <chr> "When five strangers from an online comic…
#> $ rating                 <dbl> 8.23869, 8.12515, 8.14380, 8.11400, 8.304…
#> $ votes                  <int> 1039, 839, 758, 693, 661, 689
#> $ comment_count          <int> 3, 0, 1, 1, 1, 1
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00…
#> $ updated_at             <dttm> 2019-10-04 04:49:30, 2019-10-04 12:29:56…
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
shows_trending()
#> # A tibble: 10 x 8
#>    watchers title           year trakt  slug           tvdb  imdb     tmdb 
#>       <int> <chr>          <int> <chr>  <chr>          <chr> <chr>    <chr>
#>  1      101 Grey's Anatomy  2005 1407   grey-s-anatomy 73762 tt04135… 1416 
#>  2       57 Titans          2018 127287 titans-2019    3416… tt10438… 75450
#>  3       54 Evil            2019 147814 evil           3639… tt90550… 86848
#>  4       52 Young Sheldon   2017 119172 young-sheldon  3287… tt62262… 71728
#>  5       49 Raising Dion    2019 124235 raising-dion   3359… tt78261… 93392
#>  6       48 The Good Place  2016 107700 the-good-place 3117… tt49556… 66573
#>  7       44 Chicago Fire    2012 43764  chicago-fire   2585… tt22613… 44006
#>  8       44 Goliath         2016 110358 goliath        3153… tt46878… 67384
#>  9       42 Chicago P.D.    2014 58454  chicago-p-d    2696… tt28050… 58841
#> 10       42 SEAL Team       2017 119142 seal-team      3286… tt64733… 71789
```

Maybe you want to know how long it would take you to binge through these
shows:

``` r
library(dplyr)
library(hms)
library(glue)

shows_trending(extended = "full") %>%
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

| Show                  | Episode Runtime | Aired Episodes | Total Runtime (aired) |
| :-------------------- | :-------------- | -------------: | :-------------------- |
| Grey’s Anatomy (2005) | 00:43:00        |            343 | 245:49:00             |
| Titans (2018)         | 00:50:00        |             16 | 13:20:00              |
| Evil (2019)           | 00:43:00        |              2 | 01:26:00              |
| Young Sheldon (2017)  | 00:20:00        |             46 | 15:20:00              |
| Raising Dion (2019)   | 00:45:00        |              9 | 06:45:00              |
| The Good Place (2016) | 00:22:00        |             39 | 14:18:00              |
| Chicago Fire (2012)   | 01:00:00        |            161 | 161:00:00             |
| Goliath (2016)        | 00:55:00        |             24 | 22:00:00              |
| Chicago P.D. (2014)   | 00:45:00        |            130 | 97:30:00              |
| SEAL Team (2017)      | 00:45:00        |             45 | 33:45:00              |

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
