context("SEMinR correctly bootstraps the simple model\n")

# Test cases
## Simple case
set.seed(123)
# seminr syntax for creating measurement model
mobi_mm <- measure(
  reflect("Image",        multi_items("IMAG", 1:5)),
  reflect("Expectation",  multi_items("CUEX", 1:3)),
  reflect("Value",        multi_items("PERV", 1:2)),
  reflect("Satisfaction", multi_items("CUSA", 1:3))
)

# structural model: note that name of the interactions factor should be
#  the names of its two main factors joined by a '.' in between.
mobi_sm <- structure(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value"))
)

# Load data, assemble model, and estimate using semPLS
data("mobi", package = "semPLS")
seminr_model <- estimate_model(mobi, mobi_mm, interactions = NULL, mobi_sm)
bootmodel <- bootstrap_model(mobi,mobi_mm,interactions = NULL, mobi_sm)

# Load outputs
bootmatrix <- bootmodel$bootstrapMatrix

## Output originally created using following lines
# write.csv(bootmodel$bootstrapMatrix, file = "tests/fixtures/boostrapmatrix1.csv")

# Load controls
bootmatrix_control <- as.matrix(read.csv("../fixtures/boostrapmatrix1.csv", row.names = 1))

# Testing

test_that("Seminr performs the bootstrapping correctly", {
  expect_equal(bootmatrix[,1], bootmatrix_control[,1])
})

test_that("Seminr performs the bootstrapping correctly", {
  expect_equal(bootmatrix[,2], bootmatrix_control[,2])
})

test_that("Seminr performs the bootstrapping correctly", {
  expect_equal(bootmatrix[,3], bootmatrix_control[,3])
})

context("SEMinR correctly bootstraps the interaction model\n")

# Test cases
## Interaction case

# seminr syntax for creating measurement model
mobi_mm <- measure(
  reflect("Image",        multi_items("IMAG", 1:5)),
  reflect("Expectation",  multi_items("CUEX", 1:3)),
  reflect("Value",        multi_items("PERV", 1:2)),
  reflect("Satisfaction", multi_items("CUSA", 1:3))
)

# interaction factors must be created after the measurement model is defined
mobi_xm <- interact(
  interaction_ortho("Image", "Expectation"),
  interaction_ortho("Image", "Value")
)

# structural model: note that name of the interactions factor should be
#  the names of its two main factors joined by a '.' in between.
mobi_sm <- structure(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value",
                 "Image.Expectation", "Image.Value"))
)

# Load data, assemble model, and estimate using semPLS
data("mobi", package = "semPLS")
seminr_model <- estimate_model(mobi, mobi_mm, mobi_xm, mobi_sm)
bootmodel <- bootstrap_model(mobi,mobi_mm,mobi_xm, mobi_sm,nboot = 500)

# Load outputs
bootmatrix <- bootmodel$bootstrapMatrix

## Output originally created using following lines
# write.csv(bootmodel$bootstrapMatrix, file = "tests/fixtures/boostrapmatrix2.csv")

# Load controls
bootmatrix_control <- as.matrix(read.csv("../fixtures/boostrapmatrix2.csv", row.names = 1))

# Testing

test_that("Seminr performs the bootstrapping correctly", {
  expect_equal(bootmatrix[,1], bootmatrix_control[,1])
})

test_that("Seminr performs the bootstrapping correctly", {
  expect_equal(bootmatrix[,2], bootmatrix_control[,2])
})

test_that("Seminr performs the bootstrapping correctly", {
  expect_equal(bootmatrix[,3], bootmatrix_control[,3])
})
