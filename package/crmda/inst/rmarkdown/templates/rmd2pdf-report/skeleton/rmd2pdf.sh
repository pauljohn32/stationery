#!/bin/bash

## Paul Johnson
## 2018-02-10

scriptname=`basename $0 .sh`

## Receive one filename, then build it.
compileOne(){
	filename=$1
	if [[ -e "$filename" ]]; then
		fn=$(basename "$filename")
		exten="${fn##*.}"
		## check extension, ignore case, allows "rmd" or "RMD"
		shopt -s nocasematch
		if [[ "$exten" == "Rmd" ]]; then
			echo -e "compile $filename"
			Rscript -e "library(crmda); $scriptname(\"$filename\", $parmstring); library(knitr); purl(\"$filename\")"
		else
			echo -e "Error: $filename. Extension should be \"Rmd\""
		fi
	else
 		echo -e "$filename not found"
	fi
}

## Scan directory for [Rmd,rmd] files and try to compile them
compileall() {
   	echo -e "\n""If no filename is specified, these Rmd files will be compiled:"
	echo -e "\n" $(ls -1 *.Rmd) "\n"
	echo -e "Hit Enter to continue, or \"q\" to quit"
	read -p "> " input
	if [[ $input == "q" ]]; then
   		exit 1
	else
		echo "Compiling them all"
		for fn in *.Rmd
		do
			compileOne "$fn"
		done
	fi
}


die() {
	printf '%s\n' "$1" >&2
	exit 1
}

## Only prints if DEBUG is set
showme(){
	if [ ${DEBUG} -gt 0 ]; then
		printf 'DEBUG: %s\n' "$1" >&2;
	fi
}

## Prints key=value pairs, one per line
printarr() {
	declare -n __p="$1"
	for k in "${!__p[@]}"
	do printf "     %s=%s\n" "$k" "${__p[$k]}"
	done
} 

## builds $parmstring by concatenating key=value pairs
catarr() {
	declare -n __p="$1"
	for k in "${!__p[@]}"
	do parmstring+=", $k=${__p[$k]}"
	done
} 



## Usage instruction.  
usage() {
	echo -e "\nUsage: $0 --arg=value [filename.Rmd]".
	echo -e "Note: Because this document uses a template, the yaml header"
	echo -e "format settings are ignored. Instead, specify arguments for this script."
	echo "Current arguments:"
	printarr parms
    echo -e "\nThis script reformats and sends request to R as:\n"
	echo -e "library(crmda); $scriptname(\"filename.Rmd\""$parmstring")\n"
    echo "Add argument -v for VERBOSE output."
	echo "Any arguments described in documentation for $scriptname R function are allowed."
}

## VERBOSE is flag users can turn on to get more detailed output
VERBOSE=0
## DEBUG if for author of this script, for fixing arg parsing. Not for users
DEBUG=0
pwd=`pwd`
declare -A parms
parms[toc]=TRUE
parms[toc_depth]=2
parms[clean]=TRUE
parms[quiet]=TRUE 
parms[keep_md]=FALSE
parms[type]=\"report\"
parms[template]=\"theme/guide-boilerplate.tex\"
parms[output_dir]=\"$pwd\"

optspec=":vh-:"
while getopts "$optspec" OPTCHAR; do
    case "${OPTCHAR}" in
        -)
			showme "OPTARG:  ${OPTARG[*]}"
			showme "OPTIND:  ${OPTIND[*]}"
			showme "OPTCHAR: ${OPTCHAR}"
			if [[ ${OPTARG}  == *"="* ]]; then
				showme "There is an equal sign in ${OPTARG}"
				opt=${OPTARG%=*}
				val=${OPTARG#*=}
				showme "--${opt} = \"${val}\""
			   	if [[ -z $val ]]; then
					die "ERROR: $opt is empty."
				fi
				parms[${opt}]=${val}
			elif [[ ${OPTARG} == "help" ]]; then
				## Finds "--help" Because no argument after help, then answer here
				usage
				exit
			fi
			;;
	    h)
            usage
	    	exit 2
		 	;;
        v)
			## if -v flag is present
			echo -e "\n\nverbose flag\n"
            VERBOSE=1
			parms["quiet"]="FALSE"
			## must print default parms here, before more parsing
			echo "Parameters are:" >&2
			printarr parms
			;;
        *)
             if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                 die "Undefined argument: '-${OPTARG}'"
             fi
             ;;
	esac
done

parmstring=""
catarr parms
## echo "parmstring: $parmstring"

## No shifts inside there, so must throw away arguments
## that were processed
shift "$((OPTIND-1))"

showme "After getopts, N of args left $#"
showme "Args:  $@"

if [ ${VERBOSE} -gt 0 ]; then
	echo -e "After parsing command line, the parameters are:"
	printarr parms
fi

## Retrieve the number of arguments that are left
nargs=$#
## If no arguments for file names, print usage, build all. 
if [[ $nargs -lt 1 ]]; then
	usage
	compileall
fi


for filename in "$@"; do
 	compileOne $filename
done

