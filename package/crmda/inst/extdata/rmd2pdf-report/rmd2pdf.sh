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
	 echo "Used to render from Rmd to pdf"
	    exit
	    ;;
	--) shift ; break ;;
	*) echo "Error"; exit 1 ;;
    esac
done

output_format="pdf_document(highlight=\"haddock\", template=\"theme/crmda-boilerplate.tex\", pandoc_args=\"--listings\" )"



filename=$1
fn=$(basename "$filename")
exten="${fn##*.}"

echo "$fn"
echo "$exten"


if [[ $filename == "" ||  "$exten" != "Rmd" ]]
then
    echo -e "These are the Rmd files in the current directory." 
    echo -e "\n" $(ls  *.Rmd)
    read -p "Please indicate which you want, or hit Enter for all: " filename
fi



if [[ -e $filename ]]
then
       render "$filename" "$output_format"
else
for fn in *.Rmd
do
        render "$fn" "$output_format"
done
fi
 
