
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tRakt <img src="https://jemus42.github.io/tRakt/reference/figures/logo.png" align="right" height="120"/>

<!-- badges: start -->

[![Travis
(.org)](https://img.shields.io/travis/jemus42/tRakt.svg?logo=travis)](https://travis-ci.org/jemus42/tRakt)
[![R build
status](https://github.com/jemus42/tRakt/workflows/R-CMD-check/badge.svg)](https://github.com/jemus42/tRakt/actions)
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
library(dplyr) # for convenience
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

Get episode data for the first season, this time using the show’s URL
slug:

``` r
seasons_season("utopia", seasons = 1, extended = "full") %>%
  glimpse()
#> Rows: 6
#> Columns: 16
#> $ season                 <int> 1, 1, 1, 1, 1, 1
#> $ episode                <int> 1, 2, 3, 4, 5, 6
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "Episod…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6
#> $ overview               <chr> "When five strangers from an online comic book…
#> $ rating                 <dbl> 8.23251, 8.11449, 8.12645, 8.09887, 8.28444, 8…
#> $ votes                  <int> 1058, 856, 775, 708, 675, 701
#> $ comment_count          <int> 3, 0, 1, 1, 1, 1
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00, 201…
#> $ updated_at             <dttm> 2020-04-16 16:48:01, 2020-04-16 13:35:07, 202…
#> $ available_translations <list> [<"bs", "de", "el", "en", "es", "fa", "fr", "…
#> $ runtime                <int> 50, 50, 50, 50, 50, 50
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056", "1…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748", "4…
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
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "Episod…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
#> $ overview               <chr> "When five strangers from an online comic book…
#> $ rating                 <dbl> 8.23251, 8.11449, 8.12645, 8.09887, 8.28444, 8…
#> $ votes                  <int> 1058, 856, 775, 708, 675, 701, 715, 629, 597, …
#> $ comment_count          <int> 3, 0, 1, 1, 1, 1, 1, 1, 0, 1, 2, 1
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00, 201…
#> $ updated_at             <dttm> 2020-04-16 16:48:01, 2020-04-16 13:35:07, 202…
#> $ available_translations <list> [<"bs", "de", "el", "en", "es", "fa", "fr", "…
#> $ runtime                <int> 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056", "1…
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
#>  1       83 Devs              2020 147971 devs             364149 tt81341… 81349
#>  2       77 Westworld         2016 99718  westworld        296762 tt04757… 63247
#>  3       74 Chicago Fire      2012 43764  chicago-fire     258541 tt22613… 44006
#>  4       66 Ozark             2017 119913 ozark            329089 tt50714… 69740
#>  5       57 Better Call Saul  2015 59660  better-call-saul 273181 tt30324… 60059
#>  6       57 Chicago P.D.      2014 58454  chicago-p-d      269641 tt28050… 58841
#>  7       54 Chicago Med       2015 98934  chicago-med      295640 tt46554… 62650
#>  8       51 Survivor          2000 14594  survivor-2000    76733  tt02391… 14658
#>  9       44 Brooklyn Nine-N…  2013 48587  brooklyn-nine-n… 269586 tt24673… 48891
#> 10       40 NCIS              2003 4590   ncis             72108  tt03648… 4614
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

| Show                      | Episode Runtime | Aired Episodes | Total Runtime (aired) |
| :------------------------ | :-------------- | -------------: | :-------------------- |
| Devs (2020)               | 00:52:00        |              8 | 06:56:00              |
| Westworld (2016)          | 01:00:00        |             25 | 25:00:00              |
| Chicago Fire (2012)       | 01:00:00        |            179 | 179:00:00             |
| Ozark (2017)              | 00:56:00        |             30 | 28:00:00              |
| Better Call Saul (2015)   | 00:45:00        |             49 | 36:45:00              |
| Chicago P.D. (2014)       | 00:42:00        |            148 | 103:36:00             |
| Chicago Med (2015)        | 00:42:00        |            103 | 72:06:00              |
| Survivor (2000)           | 00:42:00        |            597 | 417:54:00             |
| Brooklyn Nine-Nine (2013) | 00:21:00        |            141 | 49:21:00              |
| NCIS (2003)               | 00:45:00        |            398 | 298:30:00             |

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

  - `trakt_client_id` **Required**. It’s used in the HTTP headers for
    the API calls, which is kind of a biggie.
  - `trakt_client_secret`: **Optional**(ish). This is only required if
    you intend to make an authenticated request, which is only required
    by a [small number of implemented API
    methods](http://jemus42.github.io/tRakt/articles/Implemented-API-methods.html).
    You can use this package perfectly fine for basic data collection
    without registering an application on trakt.tv.
  - `trakt_username` **Optional**. For functions that retrieve a user’s
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
