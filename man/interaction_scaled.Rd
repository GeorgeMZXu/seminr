% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interactions.R
\name{interaction_scaled}
\alias{PLS}
\alias{SEM.}
\alias{This}
\alias{\code{interaction_scaled}}
\alias{a}
\alias{all}
\alias{automatically}
\alias{by}
\alias{combination}
\alias{creates}
\alias{factor}
\alias{for}
\alias{function}
\alias{generates}
\alias{interaction}
\alias{interaction_ortho,}
\alias{interaction_scaled}
\alias{items}
\alias{items.}
\alias{measurement}
\alias{multipying}
\alias{of}
\title{\code{interaction_ortho} creates interaction measurement items by multipying all combination of factor items.}
\usage{
# Create two new interactions (factor1.factor2 and factor1.factor3) using

 # orthogonalization approach as per Henseler & CHin (2010):
 interact( interaction_ortho("factor1", "factor2"),
           interaction_ortho("factor1", "factor3"))
}
\arguments{
\item{...}{Interaction Combinations as generated by the \code{interaction_ortho} method.}

\item{...}{Interaction Combinations as generated by the \code{interaction_scaled} method.}
}
\description{
This function automatically generates interaction measurement items for a PLS SEM.
}
\examples{
data("mobi", package = "semPLS")

mobi_xm <- interact(
  interaction_ortho("Image", "Expectation"),
  interaction_ortho("Image", "Value")
)

mobi_pls <- estimate_model(mobi, mobi_mm, mobi_xm, mobi_sm)
print_paths(mobi_pls)

}

