
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tRakt <img src="https://jemus42.github.io/tRakt/reference/figures/logo.png" align="right" height="120"/>

<!-- badges: start -->

[![R build
status](https://github.com/jemus42/tRakt/workflows/R-CMD-check/badge.svg)](https://github.com/jemus42/tRakt/actions)
[![Coverage
status](https://codecov.io/gh/jemus42/tRakt/branch/master/graph/badge.svg)](https://codecov.io/github/jemus42/tRakt?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/tRakt)](https://cran.r-project.org/package=tRakt)
[![GitHub
release](https://img.shields.io/github/release/jemus42/tRakt.svg?logo=GitHub)](https://github.com/jemus42/tRakt/releases)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

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
library(dplyr) # for convenience
library(tRakt)
```

Search for a show, get basic info:

``` r
show_info <- search_query("Utopia", type = "show")
glimpse(show_info)
#> Rows: 1
#> Columns: 9
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
#> Rows: 2
#> Columns: 13
#> $ season         <int> 1, 2
#> $ rating         <dbl> 8.64126, 8.10000
#> $ votes          <int> 223, 160
#> $ episode_count  <int> 6, 6
#> $ aired_episodes <int> 6, 6
#> $ title          <chr> "Season 1", "Season 2"
#> $ overview       <chr> "When a group of strangers find themselves in possessio…
#> $ first_aired    <dttm> 2013-01-15 21:00:00, 2014-07-14 20:00:00
#> $ updated_at     <dttm> 2021-06-02 12:27:53, 2021-06-02 11:45:24
#> $ network        <chr> "Channel 4", "Channel 4"
#> $ trakt          <chr> "56008", "56009"
#> $ tvdb           <chr> "507598", "571814"
#> $ tmdb           <chr> "54695", "54696"
```

Get episode data for the first season, this time using the show’s URL
slug:

``` r
seasons_season("utopia", seasons = 1, extended = "full") %>%
  glimpse()
#> Rows: 6
#> Columns: 16
#> $ season                 <int> 1, 1, 1, 1, 1, 1
#> $ episode                <int> 1, 2, 3, 4, 5, 6
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "Episode…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6
#> $ overview               <chr> "When five strangers from an online comic book …
#> $ rating                 <dbl> 8.20791, 8.09573, 8.09546, 8.06281, 8.22715, 8.…
#> $ votes                  <int> 1188, 961, 859, 796, 766, 788
#> $ comment_count          <int> 4, 0, 1, 1, 1, 1
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00, 2013-…
#> $ updated_at             <dttm> 2021-06-02 13:23:05, 2021-06-01 21:25:30, 2021-…
#> $ available_translations <list> <"bs", "de", "el", "en", "es", "fa", "fr", "he"…
#> $ runtime                <int> 60, 60, 60, 60, 60, 60
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056", "14…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748", "44…
#> $ imdb                   <chr> "tt2618234", "tt2618232", "tt2618236", "tt2618…
#> $ tmdb                   <chr> "910003", "910004", "910005", "910006", "91000…
```

You cann also get episode data for all seasons, but note that episodes
will be included as a list-column and need further unpacking:

``` r
seasons_summary("utopia", episodes = TRUE, extended = "full") %>%
  pull(episodes) %>%
  bind_rows() %>%
  glimpse()
#> Rows: 12
#> Columns: 16
#> $ season                 <int> 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2
#> $ episode                <int> 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "Episode…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
#> $ overview               <chr> "When five strangers from an online comic book …
#> $ rating                 <dbl> 8.20791, 8.09573, 8.09546, 8.06281, 8.22715, 8.…
#> $ votes                  <int> 1188, 961, 859, 796, 766, 788, 779, 686, 654, 6…
#> $ comment_count          <int> 4, 0, 1, 1, 1, 1, 2, 1, 1, 1, 2, 3
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00, 2013-…
#> $ updated_at             <dttm> 2021-06-02 13:23:05, 2021-06-01 21:25:30, 2021-…
#> $ available_translations <list> <"bs", "de", "el", "en", "es", "fa", "fr", "he"…
#> $ runtime                <int> 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 60
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056", "14…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748", "4…
#> $ imdb                   <chr> "tt2618234", "tt2618232", "tt2618236", "tt2618…
#> $ tmdb                   <chr> "910003", "910004", "910005", "910006", "91000…
```

Or alternatively, get the [trending
shows](https://trakt.tv/shows/trending):

``` r
shows_trending()
#> # A tibble: 10 x 8
#>    watchers title             year trakt  slug             tvdb   imdb     tmdb 
#>       <int> <chr>            <int> <chr>  <chr>            <chr>  <chr>    <chr>
#>  1       59 The Handmaid's …  2017 113938 the-handmaid-s-… 321239 tt58342… 69478
#>  2       51 Lucifer           2016 98990  lucifer          295685 tt40528… 63174
#>  3       43 Mare of Easttown  2021 153275 mare-of-easttown 370112 tt10155… 1150…
#>  4       39 Superman & Lois   2021 162205 superman-lois    375655 tt11192… 95057
#>  5       35 The Simpsons      1989 455    the-simpsons     71663  tt00966… 456  
#>  6       33 Friends           1994 1657   friends          79168  tt01087… 1668 
#>  7       32 The Big Bang Th…  2007 1409   the-big-bang-th… 80379  tt08982… 1418 
#>  8       28 The Good Doctor   2017 119095 the-good-doctor  328634 tt64704… 71712
#>  9       23 The Blacklist     2013 46676  the-blacklist    266189 tt27416… 46952
#> 10       22 New Amsterdam     2018 133258 new-amsterdam-2… 349272 tt78173… 80350
```

Maybe you just want to know how long it would take you to binge through
these shows:

``` r
shows_trending(extended = "full") %>%
  transmute(
    show = glue::glue("{title} ({year})"),
    runtime_hms = hms::hms(minutes = runtime),
    aired_episodes = aired_episodes,
    runtime_aired = hms::hms(minutes = runtime * aired_episodes)
  ) %>%
  knitr::kable(
    col.names = c("Show", "Episode Runtime", "Aired Episodes", "Total Runtime (aired)")
  )
```

| Show                       | Episode Runtime | Aired Episodes | Total Runtime (aired) |
|:---------------------------|:----------------|---------------:|:----------------------|
| The Handmaid’s Tale (2017) | 00:50:00        |             44 | 36:40:00              |
| Lucifer (2016)             | 00:45:00        |             83 | 62:15:00              |
| Mare of Easttown (2021)    | 00:57:00        |              7 | 06:39:00              |
| Superman & Lois (2021)     | 00:44:00        |              8 | 05:52:00              |
| The Simpsons (1989)        | 00:22:00        |            706 | 258:52:00             |
| Friends (1994)             | 00:25:00        |            236 | 98:20:00              |
| The Big Bang Theory (2007) | 00:22:00        |            279 | 102:18:00             |
| The Good Doctor (2017)     | 00:43:00        |             75 | 53:45:00              |
| The Blacklist (2013)       | 00:43:00        |            171 | 122:33:00             |
| New Amsterdam (2018)       | 00:43:00        |             53 | 37:59:00              |

Please note though that episode runtime data may be inaccurate. In my
experience, recent shows have fairly accurate runtimes, which might not
be case for older shows.

## Credentials

The API requires at least a `client id` for the API calls.  
Loading the package (or calling its functions via `tRakt::` wil
automatically set the app’s client id (see `?trakt_credentials()`) – for
extended use you should set your own credentials via environment
variables in your `.Renviron` like this:

``` sh
# tRakt
trakt_client_id=12fc1de7[...]3d629afdf2
trakt_client_secret=justabunchofstuffhere
trakt_username=jemus42
```

-   `trakt_client_id` **Required**. It’s used in the HTTP headers for
    the API calls, which is kind of a biggie.
-   `trakt_client_secret`: **Optional**(ish). This is only required if
    you intend to make an authenticated request, which is only required
    by a [small number of implemented API
    methods](http://jemus42.github.io/tRakt/articles/Implemented-API-methods.html).
    You can use this package perfectly fine for basic data collection
    without registering an application on trakt.tv.
-   `trakt_username` **Optional**. For functions that retrieve a user’s
    watched shows or stats, this just sets the default value so you
    don’t have to keep supplying it in individual function calls when
    you’re just looking at your own data anyway.

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
