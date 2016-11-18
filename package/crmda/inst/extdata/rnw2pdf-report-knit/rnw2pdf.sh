#!/bin/sh

fn=$1

Rscript -e "library(crmda); rnw2pdf(\"$fn\", engine = \"knitr\")"

## TODO: come back and add if logic to process all Rmd
## or lyx files
