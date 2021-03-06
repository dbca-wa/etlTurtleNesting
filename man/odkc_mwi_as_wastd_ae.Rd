% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/odkc_mwi_as_wastd_ae.R
\name{odkc_mwi_as_wastd_ae}
\alias{odkc_mwi_as_wastd_ae}
\title{Transform odkc_data$mwi into WAStD AnimalEncounters.}
\usage{
odkc_mwi_as_wastd_ae(data, user_mapping)
}
\arguments{
\item{data}{The tibble of Marine Wildlife Incidents,
e.g. \code{odkc_data$mwi}.}

\item{user_mapping}{.}
}
\value{
A tibble suitable to
\code{\link{wastd_POST}("animal-encounters")}
}
\description{
Transform odkc_data$mwi into WAStD AnimalEncounters.
}
\examples{
\dontrun{
data("odkc_data", package = "wastdr")
user_mapping <- NULL # see odkc_plan for actual user mapping
ae <- odkc_mwi_as_wastd_ae(odkc_ex$mwi, user_mapping)

ae \%>\%
  wastd_POST("animal-encounters",
    api_url = Sys.getenv("WASTDR_API_DEV_URL"),
    api_token = Sys.getenv("WASTDR_API_DEV_TOKEN")
  )
}
}
