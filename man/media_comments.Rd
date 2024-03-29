% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/movies_comments.R
\name{media_comments}
\alias{media_comments}
\alias{movies_comments}
\alias{shows_comments}
\alias{seasons_comments}
\alias{episodes_comments}
\title{Get all comments of a thing}
\source{
\code{movies_comments()} wraps endpoint \href{https://trakt.docs.apiary.io/#reference/movies/comments/get-all-movie-comments}{movies/:id/comments/:sort}.

\code{shows_comments()} wraps endpoint \href{https://trakt.docs.apiary.io/#reference/shows/comments/get-all-show-comments}{shows/:id/comments/:sort}.

\code{seasons_comments()} wraps endpoint \href{https://trakt.docs.apiary.io/#reference/seasons/comments/get-all-season-comments}{shows/:id/seasons/:season/comments/:sort}.

\code{episodes_comments()} wraps endpoint \href{https://trakt.docs.apiary.io/#reference/episodes/comments/get-all-episode-comments}{shows/:id/seasons/:season/episodes/:episode/comments/:sort}.
}
\usage{
movies_comments(
  id,
  sort = c("newest", "oldest", "likes", "replies"),
  extended = c("min", "full"),
  limit = 10L
)

shows_comments(
  id,
  sort = c("newest", "oldest", "likes", "replies"),
  extended = c("min", "full"),
  limit = 10L
)

seasons_comments(
  id,
  season = 1L,
  sort = c("newest", "oldest", "likes", "replies"),
  extended = c("min", "full"),
  limit = 10L
)

episodes_comments(
  id,
  season = 1L,
  episode = 1L,
  sort = c("newest", "oldest", "likes", "replies"),
  extended = c("min", "full"),
  limit = 10L
)
}
\arguments{
\item{id}{\code{character(1)}: The ID of the item requested. Preferably the
\code{trakt} ID (e.g. \code{1429}). Other options are the trakt.tv \code{slug} (e.g. \code{"the-wire"})
or \code{imdb} ID (e.g. \code{"tt0306414"}).
Can also be of length greater than 1, in which case the function is called on all
\code{id} values separately and the result is combined. See
\code{vignette("finding-things")} for more details.}

\item{sort}{\code{character(1) ["newest"]}: Comment sort order, one of
"newest", "oldest", "likes" or "replies".}

\item{extended}{\code{character(1)}: Either \code{"min"} (API default) or \code{"full"}. The latter
returns more variables and should generally only be used if required.
See \code{vignette("finding-things")} for more details.}

\item{limit}{\code{integer(1) [10L]}: Number of items to return. Must be greater
than \code{0} and will be coerced via \code{as.integer()}.}

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
Get all comments of a thing
}
\section{Functions}{
\itemize{
\item \code{movies_comments()}: Get comments for a movie

\item \code{shows_comments()}: Get comments for a movie

\item \code{seasons_comments()}: Get comments for a season

\item \code{episodes_comments()}: Get comments for an episode

}}
\examples{
\dontrun{
movies_comments(193972)
shows_comments(46241, sort = "likes")
seasons_comments(46241, season = 1, sort = "likes")
episodes_comments(46241, season = 1, episode = 2, sort = "likes")
}
}
\seealso{
Other comment methods: 
\code{\link{comments_comment}()},
\code{\link{comments_trending}()},
\code{\link{comments_updates}()},
\code{\link{user_comments}()},
\code{\link{user_list_comments}()}

Other movie data: 
\code{\link{anticipated_media}},
\code{\link{collected_media}},
\code{\link{media_aliases}},
\code{\link{media_lists}},
\code{\link{media_people}},
\code{\link{media_ratings}()},
\code{\link{media_stats}()},
\code{\link{media_translations}},
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
\code{\link{media_lists}},
\code{\link{media_people}},
\code{\link{media_ratings}()},
\code{\link{media_stats}()},
\code{\link{media_translations}},
\code{\link{media_watching}},
\code{\link{people_media}()},
\code{\link{played_media}},
\code{\link{shows_next_episode}()},
\code{\link{shows_related}()},
\code{\link{shows_summary}()}

Other season data: 
\code{\link{media_lists}},
\code{\link{media_people}},
\code{\link{media_ratings}()},
\code{\link{media_stats}()},
\code{\link{seasons_season}()},
\code{\link{seasons_summary}()}

Other episode data: 
\code{\link{episodes_summary}()},
\code{\link{media_lists}},
\code{\link{media_people}},
\code{\link{media_ratings}()},
\code{\link{media_stats}()},
\code{\link{media_translations}},
\code{\link{media_watching}},
\code{\link{seasons_season}()},
\code{\link{seasons_summary}()},
\code{\link{shows_next_episode}()}
}
\concept{comment methods}
\concept{episode data}
\concept{movie data}
\concept{season data}
\concept{show data}
