#!/bin/bash

## Paul Johnson 20161025
## TODO 1) check input is Rmd
## 2) If no file is provided, get list of all Rmd in
## directory and run same for them, or offer user a prompt to choose one, or all.
## Test, Run like this


function render {
	echo "In render:"
	cmd="library(rmarkdown); library(knitr); render(\"$1\", "$2", quiet = TRUE)"
	echo $cmd
    R -q --slave --vanilla -e "$cmd"
}


fmt="pdf"

TEMP=`getopt -o fh: --long fmt:,help -n 'test.sh' -- "$@"`
eval set -- "$TEMP"

while true
do
    case "$1" in
	-h|--help)
	 echo "Used to render from Rmd to pdf or html"
	    exit
	    ;;
	--) shift ; break ;;
	*) echo "Error"; exit 1 ;;
    esac
done

## echo $fmt
   output_format="pdf_document(highlight=\"haddock\", template=\"theme/crmda-boilerplate.tex\", pandoc_args=\"--listings\" )"
## echo "The fmt is $output_format"


filename=$1
## echo "Rendering: $filename into output_format $output_format"

if [[ $filename = "" ]]
then
    echo -e "These are the Rmd files in the current directory." 
    echo -e "\n" $(ls  *.Rmd)
    read -p "Please indicate which you want, or type \"all\": " filename
fi


if [[ -e $filename ]]
   then
       render "$filename" "$output_format"
fi
