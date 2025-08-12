
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tRakt <a href="https://jemus42.github.io/tRakt"><img src="man/figures/logo.png" align="right" height="139" alt="tRakt website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/jemus42/tRakt/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jemus42/tRakt/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/tRakt)](https://cran.r-project.org/package=tRakt)
[![GitHub
release](https://img.shields.io/github/release/jemus42/tRakt.svg?logo=GitHub)](https://github.com/jemus42/tRakt/releases)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Codecov test
coverage](https://codecov.io/gh/jemus42/tRakt/graph/badge.svg)](https://app.codecov.io/gh/jemus42/tRakt)
<!-- badges: end -->

`tRakt` lets you retrieve data from [trakt.tv](https://trakt.tv/), a
site similar to [IMDb](https://imdb.com) with a wider focus, yet smaller
user base. The site also enables media-center integration, so you can
automatically sync your collection and watch progress, as well as
scrobble playback and ratings via [Plex](https://www.plex.tv/),
[Kodi](https://kodi.tv/) and streaming services like Netflix and
AppleTV+.  
And, most importantly, [trakt.tv has a publicly available
API](https://trakt.docs.apiary.io), which makes this package possible
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
if (!("pak" %in% installed.packages())) {
  install.packages("pak")
}
pak::pak("jemus42/tRakt")
```

…or from [r-universe](https://jemus42.r-universe.dev/tRakt):

``` r
install.packages("tRakt", repos = "https://jemus42.r-universe.dev")
```

## Usage

``` r
library(tRakt)
library(dplyr) # for convenience
```

Search for a specific show from 2013 (and not the US adaptation) and get
basic info:

``` r
show_info <- search_query("Utopia", year = "2013", type = "show")
glimpse(show_info)
#> Rows: 1
#> Columns: 9
#> $ type  <chr> "show"
#> $ score <dbl> 5.787301e+17
#> $ title <chr> "Utopia"
#> $ year  <int> 2013
#> $ trakt <chr> "46241"
#> $ slug  <chr> "utopia"
#> $ tvdb  <chr> "264991"
#> $ imdb  <chr> "tt2384811"
#> $ tmdb  <chr> "46511"
```

We’ll use the `$trakt` ID for subsequent requests.

Get season information for the show using its trakt ID:

``` r
seasons_summary(show_info$trakt, extended = "full") |>
  glimpse()
#> Rows: 2
#> Columns: 14
#> $ season         <int> 1, 2
#> $ rating         <dbl> 8.40741, 8.08333
#> $ votes          <int> 351, 216
#> $ episode_count  <int> 6, 6
#> $ aired_episodes <int> 6, 6
#> $ title          <chr> "Season 1", "Season 2"
#> $ overview       <chr> "When a group of strangers find themselves in possessio…
#> $ first_aired    <dttm> 2013-01-15 21:00:00, 2014-07-14 20:00:00
#> $ updated_at     <dttm> 2025-08-12 06:03:40, 2025-08-12 06:03:40
#> $ network        <chr> "Channel 4", "Channel 4"
#> $ original_title <lgl> NA, NA
#> $ trakt          <chr> "56008", "56009"
#> $ tvdb           <chr> "507598", "524149"
#> $ tmdb           <chr> "54695", "54696"
```

Get episode data for the first season, this time using the show’s URL
slug:

``` r
seasons_episodes(show_info$trakt, seasons = 1, extended = "full") |>
  glimpse()
#> Rows: 6
#> Columns: 20
#> $ season                 <int> 1, 1, 1, 1, 1, 1
#> $ episode                <int> 1, 2, 3, 4, 5, 6
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "Episode…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6
#> $ overview               <chr> "When  five strangers from an online comic book…
#> $ rating                 <dbl> 8.14286, 8.03480, 8.02721, 7.99512, 8.12932, 8.…
#> $ votes                  <int> 1211, 977, 882, 820, 781, 801
#> $ comment_count          <int> 9, 0, 1, 2, 1, 2
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00, 2013-…
#> $ updated_at             <dttm> 2025-08-12 13:37:06, 2025-08-12 13:37:07, 2025-…
#> $ available_translations <list> <"de", "en", "es", "fr", "he", "nl", "pl", "ru"…
#> $ runtime                <int> 60, 49, 51, 48, 49, 62
#> $ episode_type           <chr> "series_premiere", "standard", "standard", "sta…
#> $ original_title         <lgl> NA, NA, NA, NA, NA, NA
#> $ after_credits          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
#> $ during_credits         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056", "14…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748", "4…
#> $ imdb                   <chr> "tt2618234", "tt2618232", "tt2618236", "tt2618…
#> $ tmdb                   <chr> "910003", "910004", "910005", "910006", "91000…
```

You cann also get episode data for all seasons, but note that episodes
will be included as a list-column and need further unpacking:

``` r
seasons_summary(show_info$trakt, episodes = TRUE, extended = "full") |>
  pull(episodes) |>
  bind_rows() |>
  glimpse()
#> Rows: 12
#> Columns: 20
#> $ season                 <int> 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2
#> $ episode                <int> 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "Episode…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
#> $ overview               <chr> "When  five strangers from an online comic book…
#> $ rating                 <dbl> 8.14286, 8.03480, 8.02721, 7.99512, 8.12932, 8.…
#> $ votes                  <int> 1211, 977, 882, 820, 781, 801, 796, 701, 669, 6…
#> $ comment_count          <int> 9, 0, 1, 2, 1, 2, 5, 1, 2, 2, 2, 6
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00, 2013-…
#> $ updated_at             <dttm> 2025-08-11 21:19:50, 2025-08-12 00:25:28, 2025-…
#> $ available_translations <list> <"de", "en", "es", "fr", "he", "nl", "pl", "ru"…
#> $ runtime                <int> 60, 49, 51, 48, 49, 62, 54, 51, 50, 50, 50, 53
#> $ episode_type           <chr> "series_premiere", "standard", "standard", "sta…
#> $ original_title         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ after_credits          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
#> $ during_credits         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056", "1…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748", "44…
#> $ imdb                   <chr> "tt2618234", "tt2618232", "tt2618236", "tt26182…
#> $ tmdb                   <chr> "910003", "910004", "910005", "910006", "910007…
```

Or alternatively, get the [trending
shows](https://trakt.tv/shows/trending):

``` r
shows_trending()
#> # A tibble: 10 × 8
#>    watchers title                             year trakt slug  tvdb  imdb  tmdb 
#>       <int> <chr>                            <int> <chr> <chr> <chr> <chr> <chr>
#>  1     6995 Wednesday                         2022 1739… wedn… 3970… tt13… 1190…
#>  2     4905 Dexter: Resurrection              2025 2496… dext… 4525… tt33… 2599…
#>  3     3138 The Gilded Age                    2022 1522… the-… 3644… tt44… 81723
#>  4     2900 South Park                        1997 2177  sout… 75897 tt01… 2190 
#>  5     2777 The Institute                     2025 2381… the-… 4511… tt10… 2533…
#>  6     2708 Last Week Tonight with John Oli…  2014 60267 last… 2785… tt35… 60694
#>  7     2673 Foundation                        2021 1504… foun… 3669… tt08… 93740
#>  8     2205 Star Trek: Strange New Worlds     2022 1622… star… 3823… tt12… 1035…
#>  9     2044 Twisted Metal                     2023 1882… twis… 3665… tt14… 1337…
#> 10     2020 Resident Alien                    2021 1535… resi… 3681… tt86… 96580
```

Maybe you just want to know how long it would take you to binge through
these shows:

``` r
shows_trending(extended = "full") |>
  transmute(
    show = glue::glue("{title} ({year})"),
    runtime_hms = hms::hms(minutes = runtime),
    aired_episodes = aired_episodes,
    runtime_aired = hms::hms(minutes = runtime * aired_episodes)
  ) |>
  knitr::kable(
    col.names = c("Show", "Episode Runtime", "Aired Episodes", "Total Runtime (aired)")
  )
```

| Show | Episode Runtime | Aired Episodes | Total Runtime (aired) |
|:---|:---|---:|:---|
| Wednesday (2022) | 00:42:00 | 12 | 08:24:00 |
| Dexter: Resurrection (2025) | 00:50:00 | 6 | 05:00:00 |
| The Gilded Age (2022) | 00:56:00 | 25 | 23:20:00 |
| South Park (1997) | 00:22:00 | 323 | 118:26:00 |
| The Institute (2025) | 00:58:00 | 6 | 05:48:00 |
| Last Week Tonight with John Oliver (2014) | 00:42:00 | 340 | 238:00:00 |
| Foundation (2021) | 00:42:00 | 25 | 17:30:00 |
| Star Trek: Strange New Worlds (2022) | 00:55:00 | 25 | 22:55:00 |
| Twisted Metal (2023) | 00:42:00 | 15 | 10:30:00 |
| Resident Alien (2021) | 00:45:00 | 44 | 33:00:00 |

Please note though that episode runtime data may be inaccurate. In my
experience, recent shows have fairly accurate runtime data, which is
often not the case for older shows.

## Credentials

The API requires at least a `client id` for the API calls.  
Loading the package (or calling its functions via `tRakt::` wil
automatically set the app’s credentials for authentication, but for
extended use you should set your own credentials via environment
variables in your `.Renviron` like this:

``` sh
# tRakt
trakt_client_id=12fc1de7[...]3d629afdf2
trakt_client_secret=justabunchofstuffhere
```

- `trakt_client_id` **Required**. It’s used in the HTTP headers for the
  API calls, which is kind of a biggie.
- `trakt_client_secret`: **Optional**(ish). This is only required if you
  intend to make an authenticated request, which is only required by a
  small number of implemented API methods (see
  `vignette("Implemented-API-methods")`). You can use this package
  perfectly fine for basic data collection and you can authenticate
  using the package’s credentials without registering an application on
  trakt.tv.

To get your credentials, [you have to have an (approved) app over at
trakt.tv](http://trakt.tv/oauth/applications).

You theoretically never need to supply your own credentials. However, if
you want to actually use this package for some project, I do not
recommend relying on the package’s credentials due to API rate limits.
In any case, trakt.tv is free.  
Be nice to their servers.

# Code of Conduct

Please note that the **tRakt** project is released with a [Contributor
Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this
project, you agree to abide by its terms.
