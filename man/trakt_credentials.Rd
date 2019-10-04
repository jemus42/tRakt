% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{trakt_credentials}
\alias{trakt_credentials}
\title{Set the required trakt.tv API credentials}
\usage{
trakt_credentials(username, client_id, silent = TRUE)
}
\arguments{
\item{username}{\code{character(1)}: Explicitly set your trakt.tv username
(optional).}

\item{client_id}{\code{character(1)}: Explicitly set your API client ID
(required for API interaciton).}

\item{silent}{\code{logical(1) [TRUE]}: No messages are printed showing you the
API information.
Mostly for debug purposes.}
}
\value{
Nothing. Only messages.
}
\description{
\code{trakt_credentials} searches for your credentials and stores them
in the appropriate \code{\link[=options]{options()}} variables of the same name.
To make this work automatically, place your key as environment variables in
\code{~/.Renviron} (see \code{Details}).
Arguments to this function take precedence over any key file. To make API
functions work, you do not have to use this function unless you want to
supply your own client ID, which is recommended for larger data collection
projects.
}
\details{
Set appropriate values in your \code{~/.Renviron} like this:\preformatted{# tRakt
trakt_username=jemus42
trakt_client_id=12[...]f2
trakt_client_secret=f23[...]2nkjb
}
}
\examples{
\dontrun{
# Use a values set in ~/.Renviron in an R session:
# (This is automatically executed when calling library(tRakt))
trakt_credentials()

# Explicitly set values in an R session, overriding .Renviron values
trakt_credentials(
  username = "sean",
  client_id = "12fc1de7674[...]d5e11e3490823d629afdf2",
  silent = FALSE
)
}
}
\seealso{
Other API-basics: \code{\link{search_query}},
  \code{\link{trakt_get_token}}, \code{\link{trakt_get}}
}
\concept{API-basics}