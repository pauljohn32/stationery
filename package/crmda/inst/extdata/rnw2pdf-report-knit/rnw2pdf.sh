#!/bin/sh

## Paul Johnson <pauljohn@ku.edu>

if [ $1 == "" ]
then
	filename="report-template.lyx"
else
    filename=$(basename "$1")
fi
extension="${filename##*.}"
base="${filename%.*}"
basen="${base}n.Rnw"

if [ $extension == ".lyx" ]
   then
	   lyx -e knitr "${base}.lyx"
fi
##R CMD knit "${base}.Rnw"
Rscript -e "library(knitr); knit('${base}.Rnw')"
texi2pdf "${base}.tex"

##cp "${base}.Rnw" "${basen}"
##perl -pi.bak -e 's/split=T/split=F/; s/prompt="\ *"/prompt="> "/'  $basen

Rscript -e "library(knitr); knit('${base}.Rnw', tangle = TRUE)"

mv "${base}n.R" "${base}.R"

