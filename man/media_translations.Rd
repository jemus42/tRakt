% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/movies_translations.R
\name{media_translations}
\alias{media_translations}
\alias{movies_translations}
\alias{shows_translations}
\alias{episodes_translations}
\title{Get translations for a movie, show or episode}
\source{
\code{movies_translations()} wraps endpoint \href{https://trakt.docs.apiary.io/#reference/movies/translations/get-all-movie-translations}{movies/:id/translations/:language}.

\code{shows_translations()} wraps endpoint \href{https://trakt.docs.apiary.io/#reference/shows/translations/get-all-show-translations}{shows/:id/translations/:language}.

\code{episodes_translations()} wraps endpoint \href{https://trakt.docs.apiary.io/#reference/episodes/translations/get-all-episode-translations}{shows/:id/seasons/:season/episodes/:episode/translations/:language}.
}
\usage{
movies_translations(id, languages = NULL)

shows_translations(id, languages = NULL)

episodes_translations(id, season = 1L, episode = 1L, languages = NULL)
}
\arguments{
\item{id}{\code{character(1)}: The ID of the item requested. Preferably the
\code{trakt} ID (e.g. \code{1429}). Other options are the trakt.tv \code{slug} (e.g. \code{"the-wire"})
or \code{imdb} ID (e.g. \code{"tt0306414"}).
Can also be of length greater than 1, in which case the function is called on all
\code{id} values separately and the result is combined. See
\code{vignette("finding-things")} for more details.}

\item{languages}{\code{character(n)}: Two-letter language code(s).
Also see \code{\link{trakt_languages}} for available languages (code and name).}

\item{season, episode}{\code{integer(1) [1L]}: The season and eisode number. If longer,
e.g. \code{1:5}, the function is vectorized and the output will be
combined. This may result in \emph{a lot} of API calls. Use wisely.}
}
\value{
A \link[tibble:tibble-package]{tibble()}. If the function has a \code{limit} parameter
(defaulting to \code{10}), this will be the (maximum) number of rows of the \code{tibble}.
If there are no results (or the API is unreachable), an empty \code{tibble()} is returned.
}
\description{
Get translations for a movie, show or episode
}
\examples{
# Get all translations
movies_translations("193972")

# Only get a specific language
movies_translations("193972", "de")
}
\seealso{
Other movie data: 
\code{\link{anticipated_media}},
\code{\link{collected_media}},
\code{\link{media_aliases}},
\code{\link{media_comments}},
\code{\link{media_lists}},
\code{\link{media_people}},
\code{\link{media_ratings}()},
\code{\link{media_stats}()},
\code{\link{media_watching}},
\code{\link{movies_boxoffice}()},
\code{\link{movies_related}()},
\code{\link{movies_releases}()},
\code{\link{movies_summary}()},
\code{\link{people_media}()},
\code{\link{played_media}},
\code{\link{popular_media}},
\code{\link{trending_media}},
\code{\link{watched_media}}

Other show data: 
\code{\link{collected_media}},
\code{\link{media_aliases}},
\code{\link{media_comments}},
\code{\link{media_lists}},
\code{\link{media_people}},
\code{\link{media_ratings}()},
\code{\link{media_stats}()},
\code{\link{media_watching}},
\code{\link{people_media}()},
\code{\link{played_media}},
\code{\link{shows_next_episode}()},
\code{\link{shows_related}()},
\code{\link{shows_summary}()}

Other episode data: 
\code{\link{episodes_summary}()},
\code{\link{media_comments}},
\code{\link{media_lists}},
\code{\link{media_people}},
\code{\link{media_ratings}()},
\code{\link{media_stats}()},
\code{\link{media_watching}},
\code{\link{seasons_season}()},
\code{\link{seasons_summary}()},
\code{\link{shows_next_episode}()}
}
\concept{episode data}
\concept{movie data}
\concept{show data}
