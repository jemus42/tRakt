# tRakt

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
#> Columns: 16
#> $ title          <chr> "Season 1", "Season 2"
#> $ votes          <int> 377, 226
#> $ images         <df[,2]> <data.frame[2 x 2]>
#> $ season         <int> 1, 2
#> $ rating         <dbl> 8.336870, 8.057522
#> $ network        <lgl> NA, NA
#> $ overview       <chr> "When a group of strangers find themselves in possessio…
#> $ updated_at     <dttm> 2026-03-02 01:28:02, 2026-03-02 01:28:02
#> $ first_aired    <dttm> 2013-01-15 21:00:00, 2014-07-14 20:00:00
#> $ episode_count  <int> 6, 6
#> $ aired_episodes <int> 6, 6
#> $ original_title <chr> "Season 1", "Season 2"
#> $ plex           <chr> "c(\"602e627b0f4bde002da31cdc\", \"602e627b0f4bde002da3…
#> $ tmdb           <chr> "54695", "54696"
#> $ tvdb           <chr> "507598", "524149"
#> $ trakt          <chr> "56008", "56009"
```

Get episode data for the first season, this time using the show’s URL
slug:

``` r
seasons_episodes(show_info$trakt, seasons = 1, extended = "full") |>
    glimpse()
#> Rows: 6
#> Columns: 22
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "Episode…
#> $ votes                  <int> 1214, 969, 877, 814, 784, 799
#> $ images                 <df[,1]> <data.frame[6 x 1]>
#> $ episode                <int> 1, 2, 3, 4, 5, 6
#> $ rating                 <dbl> 8.126030, 8.027864, 8.025085, 7.986486, 8.12755…
#> $ season                 <int> 1, 1, 1, 1, 1, 1
#> $ runtime                <int> 60, 49, 51, 48, 49, 62
#> $ overview               <chr> "When  five strangers from an online comic b…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6
#> $ updated_at             <dttm> 2026-03-02 00:16:11, 2026-03-02 08:04:28, 2026-…
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00, 2013-…
#> $ episode_type           <chr> "series_premiere", "standard", "standard", "sta…
#> $ after_credits          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
#> $ comment_count          <int> 9, 0, 1, 2, 2, 2
#> $ during_credits         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
#> $ original_title         <lgl> NA, NA, NA, NA, NA, NA
#> $ available_translations <list> <"de", "en", "es", "fr", "he", "nl", "pl", "ru"…
#> $ imdb                   <chr> "tt2618234", "tt2618232", "tt2618236", "tt26182…
#> $ plex                   <chr> "c(\"5d9c1007ba6eb9001fbf63c1\", \"5d9c1007ba6e…
#> $ tmdb                   <chr> "910003", "910004", "910005", "910006", "91000…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748", "4…
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056", "14…
```

You cann also get episode data for all seasons, but note that episodes
will be included as a list-column and need further unpacking:

``` r
seasons_summary(show_info$trakt, episodes = TRUE, extended = "full") |>
    pull(episodes) |>
    bind_rows() |>
    glimpse()
#> Rows: 12
#> Columns: 22
#> $ title                  <chr> "Episode 1", "Episode 2", "Episode 3", "Episode…
#> $ votes                  <int> 1214, 969, 877, 814, 784, 799, 796, 695, 664, 6…
#> $ images                 <df[,1]> <data.frame[12 x 1]>
#> $ episode                <int> 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6
#> $ rating                 <dbl> 8.126030, 8.027864, 8.025085, 7.986486, 8.12…
#> $ season                 <int> 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2
#> $ runtime                <int> 60, 49, 51, 48, 49, 62, 54, 51, 50, 50, 50, 53
#> $ overview               <chr> "When  five strangers from an online comic book…
#> $ episode_abs            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
#> $ updated_at             <dttm> 2026-03-02 00:16:11, 2026-03-02 08:04:28, 2026-…
#> $ first_aired            <dttm> 2013-01-15 21:00:00, 2013-01-22 21:00:00, 2013-…
#> $ episode_type           <chr> "series_premiere", "standard", "standard", "sta…
#> $ after_credits          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
#> $ comment_count          <int> 9, 0, 1, 2, 2, 2, 5, 1, 2, 2, 2, 7
#> $ during_credits         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
#> $ original_title         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ available_translations <list> <"de", "en", "es", "fr", "he", "nl", "pl", "ru…
#> $ imdb                   <chr> "tt2618234", "tt2618232", "tt2618236", "tt2618…
#> $ plex                   <chr> "c(\"5d9c1007ba6eb9001fbf63c1\", \"5d9c1007ba6e…
#> $ tmdb                   <chr> "910003", "910004", "910005", "910006", "910007…
#> $ tvdb                   <chr> "4471351", "4477746", "4477747", "4477748", "44…
#> $ trakt                  <chr> "1405053", "1405054", "1405055", "1405056", "14…
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

| Show                                  | Episode Runtime | Aired Episodes | Total Runtime (aired) |
|:--------------------------------------|:----------------|---------------:|:----------------------|
| The Pitt (2025)                       | 00:48:00        |             23 | 18:24:00              |
| Bridgerton (2020)                     | 01:00:00        |             32 | 32:00:00              |
| A Knight of the Seven Kingdoms (2026) | 00:35:00        |              6 | 03:30:00              |
| The Night Agent (2023)                | 00:50:00        |             30 | 25:00:00              |
| Paradise (2025)                       | 00:52:00        |             12 | 10:24:00              |
| Monarch: Legacy of Monsters (2023)    | 00:46:00        |             11 | 08:26:00              |
| Formula 1: Drive to Survive (2019)    | 00:40:00        |             78 | 52:00:00              |
| Shrinking (2023)                      | 00:35:00        |             27 | 15:45:00              |
| The Rookie (2018)                     | 00:40:00        |            134 | 89:20:00              |
| Fallout (2024)                        | 00:55:00        |             16 | 14:40:00              |

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
  [`vignette("Implemented-API-methods")`](https://jemus42.github.io/tRakt/articles/Implemented-API-methods.md)).
  You can use this package perfectly fine for basic data collection and
  you can authenticate using the package’s credentials without
  registering an application on trakt.tv.

To get your credentials, [you have to have an (approved) app over at
trakt.tv](http://trakt.tv/oauth/applications).

You theoretically never need to supply your own credentials. However, if
you want to actually use this package for some project, I do not
recommend relying on the package’s credentials due to API rate limits.
In any case, trakt.tv is free.  
Be nice to their servers.

# Code of Conduct

Please note that the **tRakt** project is released with a [Contributor
Code of Conduct](https://jemus42.github.io/tRakt/CODE_OF_CONDUCT.md). By
contributing to this project, you agree to abide by its terms.
