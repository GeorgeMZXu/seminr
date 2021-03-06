#' seminr bootstrap_model Function
#'
#' The \code{seminr} package provides a natural syntax for researchers to describe PLS
#' structural equation models. \code{seminr} is compatible with simplePLS.
#' \code{bootstrap_model} provides the verb for bootstrapping a pls model from the model
#' parameters and data.
#'
#' @param data A \code{dataframe} containing the indicator measurement data.
#'
#' @param measurement_model A source-to-target matrix representing the outer/measurement model,
#'   generated by \code{measure}.
#'
#' @param interactions A object of type \code{interact} as generated by the \code{interact}
#'   method. Default setting is \code{NULL} and can be excluded for models with no interactions.
#'
#' @param structural_model A source-to-target matrix representing the inner/structural model,
#'   generated by \code{structure}.
#'
#' @param nboot A parameter specifying the number of bootstrap iterations to perform, default
#'        value is 500. If 0 then no bootstrapping is performed.
#'
#' @param ... A list of parameters inherited from the estimation method \code{simplePLS}.
#'
#' @usage
#' bootstrap_model(data, measurement_model, interactions=NULL, structural_model, nboot = 500)
#'
#' @seealso \code{\link{structure}} \code{\link{measure}} \code{\link{paths}} \code{\link{interact}}
#'          \code{\link{create_model}} \code{\link{simplePLS}}
#'
#' @examples
#' data("mobi", package = "semPLS")
#'
#' # seminr syntax for creating measurement model
#' mobi_mm <- measure(
#'   reflect("Image",        multi_items("IMAG", 1:5)),
#'   reflect("Expectation",  multi_items("CUEX", 1:3)),
#'   reflect("Value",        multi_items("PERV", 1:2)),
#'   reflect("Satisfaction", multi_items("CUSA", 1:3))
#' )
#'
#' # interaction factors must be created after the measurement model is defined
#' mobi_xm <- interact(
#'   interaction_ortho("Image", "Expectation"),
#'   interaction_ortho("Image", "Value")
#' )
#'
#' # structural model: note that name of the interactions factor should be
#' #  the names of its two main factors joined by a '.' in between.
#' mobi_sm <- structure(
#'   paths(to = "Satisfaction",
#'         from = c("Image", "Expectation", "Value",
#'                  "Image.Expectation", "Image.Value"))
#' )
#'
#' # Load data, assemble model, and bootstrap using simplePLS
#' mobi_pls <- bootstrap_model(data = mobi,
#'                             measurement_model = mobi_mm,
#'                             interaction = mobi_xm,
#'                             structural_model = mobi_sm,
#'                             nboot = 500)
#'
#' print_paths(mobi_pls)
#' @export
bootstrap_model <- function(data, measurement_model, interactions=NULL, structural_model, nboot = 500, ...) {
  cat("Bootstrapping model using simplePLS...\n")
  library(parallel)
  capture.output(seminr_model <- estimate_model(data = data,
                                                measurement_model = measurement_model,
                                                interactions = interactions,
                                                structural_model = structural_model, ...))

  if (nboot > 0) {
    # Initialize the cluster
    cl <- makeCluster(detectCores())

    # Initialize the Estimates Matrix
    bootstrapMatrix <- seminr_model$path_coef
    cols <- ncol(bootstrapMatrix)
    rows <- nrow(bootstrapMatrix)

    # Function to generate random samples with replacement
    getRandomIndex <- function(d) {return(sample.int(nrow(d),replace = TRUE))}

    d <- data

    # Export variables and functions to cluster
    clusterExport(cl=cl, varlist=c("measurement_model", "interactions", "structural_model","getRandomIndex","d"), envir=environment())

    # Function to get PLS estimate results
    getEstimateResults <- function(i, d = d) {
      return(seminr::estimate_model(data = d[getRandomIndex(d),],
                          measurement_model,interactions,structural_model)$path_coef)
    }

    # Bootstrap the estimates
    capture.output(bootmatrix <- parSapply(cl,1:nboot,getEstimateResults, d))

    # Add the columns for bootstrap mean and standard error
    bootstrapMatrix <- cbind(bootstrapMatrix,matrix(apply(bootmatrix,1,mean),nrow = rows, ncol = cols))
    bootstrapMatrix <- cbind(bootstrapMatrix,matrix(apply(bootmatrix,1,sd),nrow = rows, ncol = cols))

    # Clean the empty paths
    bootstrapMatrix <- bootstrapMatrix[, colSums(bootstrapMatrix != 0, na.rm = TRUE) > 0]
    bootstrapMatrix <- bootstrapMatrix[rowSums(bootstrapMatrix != 0, na.rm = TRUE) > 0,]

    # Get the number of DVs
    if (length(unique(structural_model[,"target"])) == 1) {
      dependant <- unique(structural_model[,"target"])
    } else {
      dependant <- colnames(bootstrapMatrix[,1:length(unique(structural_model[,"target"]))])
    }

    # Construct the vector of column names
    colnames<-c()
    # Clean the column names
    for (parameter in c("PLS Est.", "Boot Mean", "Boot SE")) {
      for(i in 1:length(dependant)) {
        colnames <- c(colnames, paste(dependant[i],parameter,sep = " "))
      }
    }

    # Assign column names
    colnames(bootstrapMatrix) <- colnames

    # Add the bootstrap matrix to the simplePLS object
    seminr_model$bootstrapMatrix <- bootstrapMatrix
    stopCluster(cl)
  }
  seminr_model$boots <- nboot
  return(seminr_model)
}
