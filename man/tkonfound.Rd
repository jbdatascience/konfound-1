% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tkonfound.R
\name{tkonfound}
\alias{tkonfound}
\title{Perform sensitivity analysis for a 2x2 table}
\usage{
tkonfound(a, b, c, d, thr_p = 0.05, switch_trm = T)
}
\arguments{
\item{a}{cell is the number of cases in the control group showing unsuccessful results}

\item{b}{cell is the number of cases in the control group showing successful results}

\item{c}{cell is the number of cases in the treatment group showing unsuccessful results}

\item{d}{cell is the number of cases in the treatment group showing successful results}

\item{thr_p}{the p-value threshold used to evaluate statistical significance, with the default of 0.05}

\item{switch_trm}{whether switching the two cells in the treatment row or the two cells in the control row, with the default of the treatment row}
}
\value{
prints a 2x2 table after switching cases from one cell to another so that the inference is invalidated about the association between the rows and columns
}
\description{
This function calculates the number of cases (RIS) that would have to be switched from one cell to another of a 2x2 table to invalidate an inference made about the association between the rows and columns. This can be applied to treatment vs control with successful vs unsuccessful outcomes.
}
\examples{
# using tkonfound for a 2x2 table
tkonfound(35, 17, 17, 38)
tkonfound(35, 17, 17, 38, thr_p = 0.01)
tkonfound(35, 17, 17, 38, thr_p = 0.01, switch_trm = FALSE)
}
