# This example recreates the ECSI model on mobile users found at:
#  https://cran.r-project.org/web/packages/semPLS/vignettes/semPLS-intro.pdf

library(seminr)
# Simple Style: Seperate declaration of measurement,interactions and structural model.

# First, using the orthogonalization method as per Henseler & Chin (2010).
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

# Load data, assemble model, and estimate using simplePLS
data("mobi", package = "semPLS")
mobi_pls <- estimate_model(data = mobi,
                           measurement_model = mobi_mm,
                           interaction = mobi_xm,
                           structural_model = mobi_sm)

print_paths(mobi_pls)

# Bootstrap the model
mobi_pls <- bootstrap_model(data = mobi,
                            measurement_model = mobi_mm,
                            interaction = mobi_xm,
                            structural_model = mobi_sm,
                            nboot = 500)

print_paths(mobi_pls)

# Second, using the standardized product indicator method as per Henseler & Chin (2010).
# seminr syntax for creating measurement model
mobi_mm <- measure(
  reflect("Image",        multi_items("IMAG", 1:5)),
  reflect("Expectation",  multi_items("CUEX", 1:3)),
  reflect("Value",        multi_items("PERV", 1:2)),
  reflect("Satisfaction", multi_items("CUSA", 1:3))
)

# interaction factors must be created after the measurement model is defined
mobi_xm <- interact(
  interaction_scaled("Image", "Expectation"),
  interaction_scaled("Image", "Value")
)

# structural model: note that name of the interactions factor should be
#  the names of its two main factors joined by a '.' in between.
mobi_sm <- structure(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value",
                 "Image.Expectation", "Image.Value"))
)

# Load data, assemble model, and estimate using simplePLS
data("mobi", package = "semPLS")
mobi_pls <- estimate_model(data = mobi,
                           measurement_model = mobi_mm,
                           interaction = mobi_xm,
                           structural_model = mobi_sm)

print_paths(mobi_pls)

# Bootstrap the model
mobi_pls <- bootstrap_model(data = mobi,
                            measurement_model = mobi_mm,
                            interaction = mobi_xm,
                            structural_model = mobi_sm,
                            nboot = 500)

print_paths(mobi_pls)
