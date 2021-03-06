% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model.R
\name{estimate_model}
\alias{estimate_model}
\title{seminr estimate_model Function}
\usage{
estimate_model(data, measurement_model, interactions=NULL, structural_model)
}
\arguments{
\item{data}{A \code{dataframe} containing the indicator measurement data.}

\item{measurement_model}{A source-to-target matrix representing the outer/measurement model,
generated by \code{measure}.}

\item{interactions}{A object of type \code{interact} as generated by the \code{interact}
method. Default setting is \code{NULL} and can be excluded for models with no interactions.}

\item{structural_model}{A source-to-target matrix representing the inner/structural model,
generated by \code{structure}.}
}
\description{
The \code{seminr} package provides a natural syntax for researchers to describe PLS
structural equation models. \code{seminr} is compatible with semPLS, simplePLS and matrixPLS,
meaning that once a model is specified, it can be used across models for comparison. \code{create_model}
provides the verb for generating a plsm model object from the specified structural, interaction and
model specifications.
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

print_paths(mobi_pls)
plot_scores(mobi_pls)
}
\seealso{
\code{\link{structure}} \code{\link{measure}} \code{\link{paths}} \code{\link{interact}}
         \code{\link{bootstrap_model}}
}

