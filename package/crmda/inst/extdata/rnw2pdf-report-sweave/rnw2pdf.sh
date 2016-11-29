#!/bin/sh

## Paul Johnson
## 2016-11-28

## This sweaves files from Sweave-syle "noweb" markup. See "engine" below.

## On command line, run 

## 1 "./rnw2pdf.sh your_file.Rnw" to process "your_file.Rnw".
##   Also works with "your_file.lyx" 
## 2 "./rnw2pdf.sh *.Rnw" to process all Rnw files (or *.lyx for
## all lyx files.

flz=$@

for fn in $flz
  do 
     echo $fn
     Rscript -e "library(crmda); rnw2pdf(\"$fn\", engine = \"sweave\")"
  done

exit 0

