## Paul Johnson
## 20171012

library(crmda)

## Change to the temporary directory
dir.orig <- getwd()
dir.temp <- tempdir()
setwd(dir.temp)

## document types
doctype <- c("rmd2html-guide", "rmd2pdf-report",
           "rnw2pdf-guide-knit", "rnw2pdf-guide-sweave",
           "rmd2pdf-guide", "rnw2pdf-report-knit",
           "rnw2pdf-report-sweave", "rnw2pdf-slides-sweave")

res <- unlist(lapply(doctype, initWriteup, dir = "todaytest"))

res

## go into those directories and compile some documents
