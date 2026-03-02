# Make an API call and receive parsed output

The most basic form of API interaction: Querying a specific URL and
getting its parsed result. If the response is empty, the function
returns an empty
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html),
and if there are date-time variables present in the response, they are
converted to `POSIXct` via
[`lubridate::ymd_hms()`](https://lubridate.tidyverse.org/reference/ymd_hms.html)
or to `Date` via
[`lubridate::as_date()`](https://lubridate.tidyverse.org/reference/as_date.html)
if the variable only contains date information.

## Usage

``` r
trakt_get(url)
```

## Arguments

- url:

  `character(1)`: The API endpoint. Either a full URL like
  `"https://api.trakt.tv/shows/breaking-bad"` or just the endpoint like
  `shows/breaking-bad`.

## Value

The parsed content of the API response. An empty
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html)
if the response is an empty `JSON` array.

## Details

See [the official API reference](https://trakt.docs.apiary.io) for a
detailed overview of available methods. Most methods of potential
interest for data collection have dedicated functions in this package.

## Examples

``` r
# A simple request to a direct URL
trakt_get("https://api.trakt.tv/shows/breaking-bad")
#> $ids
#> $ids$imdb
#> [1] "tt0903747"
#> 
#> $ids$plex
#> $ids$plex$guid
#> [1] "5d9c083402391c001f583d09"
#> 
#> $ids$plex$slug
#> [1] "breaking-bad"
#> 
#> 
#> $ids$slug
#> [1] "breaking-bad"
#> 
#> $ids$tmdb
#> [1] 1396
#> 
#> $ids$tvdb
#> [1] 81189
#> 
#> $ids$trakt
#> [1] 1388
#> 
#> 
#> $airs
#> $airs$day
#> [1] "Sunday"
#> 
#> $airs$time
#> [1] "21:00"
#> 
#> $airs$timezone
#> [1] "America/New_York"
#> 
#> 
#> $year
#> [1] 2008
#> 
#> $title
#> [1] "Breaking Bad"
#> 
#> $votes
#> [1] 115193
#> 
#> $colors
#> $colors$poster
#> [1] "#A5AF96" "#272A2E"
#> 
#> 
#> $genres
#> [1] "drama"    "crime"    "thriller"
#> 
#> $images
#> $images$logo
#> [1] "media.trakt.tv/images/shows/000/001/388/logos/medium/d8abdb2dee.png.webp"
#> 
#> $images$thumb
#> [1] "media.trakt.tv/images/shows/000/001/388/thumbs/medium/e348e4a03f.jpg.webp"
#> 
#> $images$banner
#> [1] "media.trakt.tv/images/shows/000/001/388/banners/medium/c53872a7e2.jpg.webp"
#> 
#> $images$fanart
#> [1] "media.trakt.tv/images/shows/000/001/388/fanarts/medium/fdbc0cb02d.jpg.webp"
#> 
#> $images$poster
#> [1] "media.trakt.tv/images/shows/000/001/388/posters/medium/fa39b59954.jpg.webp"
#> 
#> $images$clearart
#> [1] "media.trakt.tv/images/shows/000/001/388/cleararts/medium/1f00520834.png.webp"
#> 
#> 
#> $rating
#> [1] 9.244034
#> 
#> $status
#> [1] "ended"
#> 
#> $country
#> [1] "us"
#> 
#> $network
#> [1] "AMC"
#> 
#> $runtime
#> [1] 50
#> 
#> $tagline
#> [1] "Change the equation."
#> 
#> $trailer
#> [1] "https://youtube.com/watch?v=XZ8daibM3AE"
#> 
#> $homepage
#> [1] "https://www.sonypictures.com/tv/breakingbad"
#> 
#> $language
#> [1] "en"
#> 
#> $overview
#> [1] "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime."
#> 
#> $languages
#> [1] "en" "de" "es"
#> 
#> $subgenres
#>  [1] "criminal"            "drugs"               "dark-comedy"        
#>  [4] "drug-dealer"         "psychopath"          "high-school-teacher"
#>  [7] "dark"                "tragedy"             "neo-western"        
#> [10] "outlaw"             
#> 
#> $updated_at
#> [1] "2026-03-02 06:38:59 UTC"
#> 
#> $first_aired
#> [1] "2008-01-21 02:00:00 UTC"
#> 
#> $certification
#> [1] "TV-MA"
#> 
#> $comment_count
#> [1] 522
#> 
#> $aired_episodes
#> [1] 62
#> 
#> $original_title
#> [1] "Breaking Bad"
#> 
#> $available_translations
#>  [1] "ar" "bg" "bs" "ca" "cs" "da" "de" "el" "en" "es" "et" "fa" "fi" "fr" "he"
#> [16] "hi" "hr" "hu" "id" "it" "ja" "ka" "ko" "lt" "lv" "nl" "no" "pl" "pt" "ro"
#> [31] "ru" "sk" "sl" "sr" "sv" "th" "tr" "uk" "vi" "zh"
#> 

# Optionally be lazy about URL specification by dropping the hostname:
trakt_get("shows/game-of-thrones")
#> $ids
#> $ids$imdb
#> [1] "tt0944947"
#> 
#> $ids$plex
#> $ids$plex$guid
#> [1] "5d9c086c46115600200aa2fe"
#> 
#> $ids$plex$slug
#> [1] "game-of-thrones"
#> 
#> 
#> $ids$slug
#> [1] "game-of-thrones"
#> 
#> $ids$tmdb
#> [1] 1399
#> 
#> $ids$tvdb
#> [1] 121361
#> 
#> $ids$trakt
#> [1] 1390
#> 
#> 
#> $airs
#> $airs$day
#> [1] "Sunday"
#> 
#> $airs$time
#> [1] "21:00"
#> 
#> $airs$timezone
#> [1] "America/New_York"
#> 
#> 
#> $year
#> [1] 2011
#> 
#> $title
#> [1] "Game of Thrones"
#> 
#> $votes
#> [1] 145230
#> 
#> $colors
#> $colors$poster
#> [1] "#AD836A" "#261713"
#> 
#> 
#> $genres
#> [1] "fantasy"   "drama"     "action"    "adventure"
#> 
#> $images
#> $images$logo
#> [1] "media.trakt.tv/images/shows/000/001/390/logos/medium/13b614ad43.png.webp"
#> 
#> $images$thumb
#> [1] "media.trakt.tv/images/shows/000/001/390/thumbs/medium/7beccbd5a1.jpg.webp"
#> 
#> $images$banner
#> [1] "media.trakt.tv/images/shows/000/001/390/banners/medium/9fefff703d.jpg.webp"
#> 
#> $images$fanart
#> [1] "media.trakt.tv/images/shows/000/001/390/fanarts/medium/76d5df8aed.jpg.webp"
#> 
#> $images$poster
#> [1] "media.trakt.tv/images/shows/000/001/390/posters/medium/93df9cd612.jpg.webp"
#> 
#> $images$clearart
#> [1] "media.trakt.tv/images/shows/000/001/390/cleararts/medium/5cbde9e647.png.webp"
#> 
#> 
#> $rating
#> [1] 8.89129
#> 
#> $status
#> [1] "ended"
#> 
#> $country
#> [1] "us"
#> 
#> $network
#> [1] "HBO"
#> 
#> $runtime
#> [1] 55
#> 
#> $tagline
#> [1] "Winter is coming."
#> 
#> $trailer
#> [1] "https://youtube.com/watch?v=KPLWWIOCOOQ"
#> 
#> $homepage
#> [1] "https://www.hbo.com/game-of-thrones"
#> 
#> $language
#> [1] "en"
#> 
#> $overview
#> [1] "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond."
#> 
#> $languages
#> [1] "en"
#> 
#> $subgenres
#> [1] "fantasy-world" "dragon"        "kingdom"       "king"         
#> 
#> $updated_at
#> [1] "2026-03-01 15:30:59 UTC"
#> 
#> $first_aired
#> [1] "2011-04-18 01:00:00 UTC"
#> 
#> $certification
#> [1] "TV-MA"
#> 
#> $comment_count
#> [1] 450
#> 
#> $aired_episodes
#> [1] 73
#> 
#> $original_title
#> [1] "Game of Thrones"
#> 
#> $available_translations
#>  [1] "ar" "be" "bg" "bs" "ca" "cs" "da" "de" "el" "en" "eo" "es" "et" "fa" "fi"
#> [16] "fr" "he" "hr" "hu" "id" "is" "it" "ja" "ka" "ko" "lb" "lt" "lv" "ml" "nl"
#> [31] "no" "pl" "pt" "ro" "ru" "sk" "sl" "so" "sr" "sv" "ta" "th" "tr" "tw" "uk"
#> [46] "uz" "vi" "zh"
#> 
```
