% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/w2_pit_as_wastd_tagobs.R
\name{w2_pit_as_wastd_tagobs}
\alias{w2_pit_as_wastd_tagobs}
\title{Transform w2_data into WAStD TagObservations.}
\usage{
w2_pit_as_wastd_tagobs(data)
}
\arguments{
\item{data}{Data of class \code{wamtram_data}.}

\item{user_mapping}{The output of \code{make_user_mapping_w2()}.}
}
\value{
A tibble suitable to
\code{\link{wastd_POST}("tag-observations")}
}
\description{
Transform w2_data into WAStD TagObservations.
}
\examples{
\dontrun{

}
}
\seealso{
https://github.com/dbca-wa/wastd/blob/master/wastd/observations/utils.py#L1849
}
