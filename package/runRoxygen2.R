PACKAGE <- "crmda"
options(repos = c("http://rweb.crmda.ku.edu/kran", "http://rweb.crmda.ku.edu/cran"))
library(roxygen2)
roxygenize(PACKAGE)
roxygenize(paste0(PACKAGE, ".gitex"))

