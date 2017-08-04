#!/bin/sh

## Paul Johnson
## 2017-08-04

## This calls the R function rmd2html in crmda. It should
## do the exact same thing.
## This replaces the more intricate shell script we were
## using, please notify me of errors.

## On command line, run 

## 1 "./rmd2html.sh your_file.Rnw" to process "your_file.Rnw".
## 2 "./rmd2html.sh *.Rnw" to process all Rnw files (or *.lyx for
## all lyx files.

## The rmd2html function is fully documented in the crmda R
## package. It can accept many arguments, which can be
## inserted below in "defaults".  If it becomes popular to
## do this, we will create a command line handler.

flz=$@

## TODO: insert check on file type. Should be Rmd
pwd=`pwd`
defaults="toc=TRUE, output_dir=\"$pwd\""

for fn in $flz
  do 
      echo $fn
	  echo $defaults
     Rscript -e "library(crmda); rmd2html(\"$fn\", $defaults)"
  done

exit 0

