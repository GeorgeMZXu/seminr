% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/consistent.R
\name{PLSc}
\alias{PLSc}
\title{seminr PLSc Function}
\usage{
PLSc(seminr_model)
}
\arguments{
\item{plsModel}{A \code{seminr_model} containing the estimated seminr model.}
}
\description{
The \code{PLSc} function calculates the consistent PLS path coefficients and loadings for
a common factor model. It returns a \code{seminr_model} containing the adjusted and consistent
path coefficients and loadings for common factor models and composite models.
}
\examples{
data("mobi", package = "semPLS")

#seminr syntax for creating measurement model
mobi_mm <- measure(
             reflect("Image",        multi_items("IMAG", 1:5)),
             reflect("Expectation",  multi_items("CUEX", 1:3)),
             reflect("Quality",      multi_items("PERQ", 1:7)),
             reflect("Value",        multi_items("PERV", 1:2)),
             reflect("Satisfaction", multi_items("CUSA", 1:3)),
             reflect("Complaints",   single_item("CUSCO")),
             reflect("Loyalty",      multi_items("CUSL", 1:3))
           )
#seminr syntax for creating structural model
mobi_sm <- structure(
  paths(from = "Image",        to = c("Expectation", "Satisfaction", "Loyalty")),
  paths(from = "Expectation",  to = c("Quality", "Value", "Satisfaction")),
  paths(from = "Quality",      to = c("Value", "Satisfaction")),
  paths(from = "Value",        to = c("Satisfaction")),
  paths(from = "Satisfaction", to = c("Complaints", "Loyalty")),
  paths(from = "Complaints",   to = "Loyalty")
)

mobi_pls <- estimate_model(data = mobi,
                           measurement_model = mobi_mm,
                           structural_model = mobi_sm)

PLSc(mobi_pls)
}
\seealso{
\code{\link{structure}} \code{\link{measure}} \code{\link{paths}} \code{\link{interact}}
         \code{\link{bootstrap_model}}
}

