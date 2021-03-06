% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/odkc_tracks_as_tnhe.R
\name{odkc_tracks_as_tnhe}
\alias{odkc_tracks_as_tnhe}
\title{Transform odkc_data$tracks into WAStD TurtleNestHatchlingEmergences.}
\usage{
odkc_tracks_as_tnhe(data)
}
\arguments{
\item{data}{A tibble of tracks,  e.g. \code{odkc_data$tracks}.}
}
\value{
A tibble suitable to
\code{\link{wastd_POST}("turtle-nest-hatchling-emergences")}
}
\description{
Transform odkc_data$tracks into WAStD TurtleNestHatchlingEmergences.
}
\examples{
\dontrun{
data("odkc_data", package = "wastdr")
au <- Sys.getenv("WASTDR_API_DEV_URL")
at <- Sys.getenv("WASTDR_API_DEV_TOKEN")
x <- odkc_tracks_as_tnhe(odkc_ex$tracks)
x \%>\% wastd_POST(
  serializer = "turtle-nest-hatchling-emergences",
  api_url = au, api_token = at
)
}
}
