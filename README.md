To clone this, run

git clone git@gitlab.crmda.ku.edu:software/crmda.git

This package is for use of CRMDA employees and affiliates. It is 
not distributed on CRAN, but rather only on the server we call
KRAN. 

To install, we suggest creating a script:

    CRAN <- "http://rweb.crmda.ku.edu/cran"
    KRAN <- "http://rweb.crmda.ku.edu/kran"
 
    options(repos = c(KRAN, CRAN))
    update.packages(ask = FALSE, checkBuilt = TRUE)

    install.packages("crmda")


We will create functions in there to initialize new reports 
of various types.