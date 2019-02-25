#' Game of Thrones episodes
#'
#' This data comes from <https://trakt.tv> and
#'  <https://en.wikipedia.org/wiki/List_of_House_episodes>.
#'
#' @format A [tibble][tibble::tibble-package] with 60 rows and 21 variables:
#' \describe{
#' \item{episode_abs}{Overall episode number}
#' \item{episode, season}{Episode within each season and season number}
#' \item{epid}{Episode ID in `s00e00` format}
#' \item{runtime}{Runtime in minutes}
#' \item{title}{Episode title}
#' \item{year}{Year of first airing}
#' \item{overview}{Episode summary}
#' \item{rating_}{Rating (1-10) on IMDb and trakt.tv}
#' \item{votes}{Number of votes and trakt.tv}
#' \item{viewers}{Number of viewers (US) in millions}
#' \item{director, writer}{Direction and writing credits}
#' \item{first_aired, first_aired.string}{Original airdate in UTC as
#'      `POSIXct` and `character`}
#' \item{trakt, tvdb, tmdb}{Episode IDs for trakt.tv, TVDb, and TMDb}
#' }
#' @family Episode datasets
#' @examples
#' gameofthrones
"gameofthrones"


#' Futurama episodes
#'
#' This data comes from <https://trakt.tv> and serves as an example of episode data output.
#'
#' @format A [tibble][tibble::tibble-package] with 124 rows and 18 variables:
#' \describe{
#' \item{episode, season}{Episode within each season and season number}
#' \item{title}{Episode title}
#' \item{episode_abs}{Overall episode number}
#' \item{overview}{Episode summary}
#' \item{rating}{Rating (1-10) on  trakt.tv}
#' \item{votes}{Number of votes ontrakt.tv}
#' \item{comment_count}{Number of comments on episode page}
#' \item{first_aired, updated_at}{Original air date and last update in UTC as `POSIXct`}
#' \item{runtime}{Runtime in minutes}
#' \item{trakt, tvdb, tmdb, tvrage}{Episode IDs for trakt.tv, TVDb, and TMDb}
#' \item{year}{Year of first airing}
#' \item{epid}{Episode ID in `s00e00` format}
#' }
#' @family Episode datasets
#' @examples
#' futurama
"futurama"
