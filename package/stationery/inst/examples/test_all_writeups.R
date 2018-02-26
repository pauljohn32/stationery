## Paul Johnson
## 20171012

library(stationery)

## Change to the temporary directory
dir.orig <- getwd()
dir.temp <- tempdir()
## dir.temp <- "/tmp/pj"
## dir.create(dir.temp)
setwd(dir.temp)

## document types
doctype <- c("rmd2html-guide", "rmd2pdf-report",
           "rnw2pdf-guide-knit", "rnw2pdf-guide-sweave",
           "rmd2pdf-guide", "rnw2pdf-report-knit",
           "rnw2pdf-report-sweave", "rnw2pdf-slides-sweave")

res <- unlist(lapply(doctype, initWriteup, dir = "todaytest"))

res

## go into those directories and compile some documents

setwd(res[1])
list.files()
