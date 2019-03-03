#' Game of Thrones episodes
#'
#' This data comes from <https://trakt.tv> and
#'  <https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_episodes>.
#'
#' @format A [tibble()][tibble::tibble-package] with 67 rows and 17 variables:
#' \describe{
#' \item{episode_abs}{Overall episode number}
#' \item{episode, season}{Episode within each season and season number}
#' \item{title}{Episode title}
#' \item{overview}{Episode summary}
#' \item{rating}{Rating (1-10) on  trakt.tv}
#' \item{votes}{Number of votes ontrakt.tv}
#' \item{viewers}{Viewers according to Wikipedia}
#' \item{director, writer}{Directing and writing credits}
#' \item{comment_count}{Number of comments on episode page}
#' \item{first_aired, updated_at}{Original air date and last update in UTC as `POSIXct`}
#' \item{runtime}{Runtime in minutes}
#' \item{trakt, tvdb, tmdb}{Episode IDs for trakt.tv, TVDb, and TMDb}
#' \item{year}{Year of first airing}
#' \item{epid}{Episode ID in `s00e00` format}
#' }
#' @family Episode datasets
#' @examples
#' gameofthrones
"gameofthrones"


#' Futurama episodes
#'
#' This data comes from <https://trakt.tv> and serves as an example of episode data output.
#'
#' @format A [tibble()][tibble::tibble-package] with 124 rows and 18 variables:
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
#' \item{trakt, tvdb, tmdb}{Episode IDs for trakt.tv, TVDb, and TMDb}
#' \item{year}{Year of first airing}
#' \item{epid}{Episode ID in `s00e00` format}
#' }
#' @family Episode datasets
#' @examples
#' futurama
"futurama"
