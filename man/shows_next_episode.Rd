% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shows_nest_episode.R
\name{shows_next_episode}
\alias{shows_next_episode}
\alias{shows_last_episode}
\title{Get a shows next or latest episode}
\usage{
shows_next_episode(id, extended = c("min", "full"))

shows_last_episode(id, extended = c("min", "full"))
}
\arguments{
\item{id}{\code{character(1)}: The ID of the item requested. Preferably the
\code{trakt} ID (e.g. \code{1429}). Other options are the trakt.tv \code{slug} (e.g. \code{"the-wire"})
or \code{imdb} ID (e.g. \code{"tt0306414"}).
Can also be of length greater than 1, in which case the function is called on all
\code{id} values separately and the result is combined. See section
\link[=trakt_api_common_parameters]{"Item identifiers"} for more details.}

\item{extended}{\code{character(1)}: Either \code{"min"} (API default) or \code{"full"}. The latter
returns more variables and should generally only be used if required.
See section \link[=trakt_api_common_parameters]{"Extended Information"} for more details.}
}
\value{
A \link[tibble:tibble-package]{tibble()}.
}
\description{
Get a shows next or latest episode
}
\examples{
shows_next_episode("one-piece")
shows_last_episode("one-piece")
}