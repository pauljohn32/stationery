#!/bin/bash

## Paul Johnson
## 2017-08-04


## all Rmd files in working directory are compiled
compileall() {
	for fn in *.Rmd
	do
		Rscript -e "library(crmda); rmd2pdf(\"$fn\", $defaults)"
	done
}

## Usage instruction, will compile all if user hits enter.
usage() {
  echo -e "\nUsage: $0 [filename.Rmd]"
  echo "No name is specified, so these Rmd files will be compiled:"
  echo -e "\n" $(ls -1 *.Rmd) "\n"
  echo -e "Hit Enter to process all Rmd files, or \"q\" to quit"
  read -p "> " input
  if [[ $input == "q" ]]; then
   	  exit 1
  else
  echo "Compiling them all"
  compileall
  fi
}

pwd=`pwd`
## The defaults string is R expression, inserted after
## the file name argument in rmd2pdf
defaults="toc=TRUE, output_dir=\"$pwd\", clean=TRUE, keep_tex=FALSE, quiet=TRUE, template=\"theme/crmda-boilerplate.tex\""
## If there is trouble compiling, use this instead
## defaults="toc=TRUE, output_dir=\"$pwd\", clean=FALSE, keep_tex=TRUE, quiet=FALSE, template=\"theme/crmda-boilerplate.tex\""

## Retrieve the number of arguments
nargs=$#

## If no arguments, or if argument is "--help"
if [[ $nargs -lt 1 ]]; then
	usage
elif [ "$1" == "--help" ]; then
	usage
fi

## Process command line file names. Error on files that are not
## suffixed with Rmd (ignoring case)
for filename in "$@"; do
	if [[ -e "$filename" ]]; then
		fn=$(basename "$filename")
		exten="${fn##*.}"
		## check extension, ignore case, allows "rmd" or "RMD"
		shopt -s nocasematch
		if [[ "$exten" == "Rmd" ]]; then
			echo -e "compile $filename"
			Rscript -e "library(crmda); rmd2pdf(\"$filename\", $defaults)"
		else
			echo -e "Error: $filename. Extension should be \"Rmd\""
		fi
	else
 		echo -e "$filename not found"
	fi
done
exit 0

