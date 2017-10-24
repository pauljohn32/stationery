#!/bin/bash

## Paul Johnson
## 2017-08-08


## all Rmd files in working directory are compiled
compileall() {
	for fn in *.Rmd
	do
		Rscript -e "library(crmda); rmd2html(\"$fn\", $parmstring)"
	done
}


die() {
	printf '%s\n' "$1" >&2
	exit 1
}


showme(){
	if [ ${VERBOSE} -gt 0 ]; then
		printf 'VERBOSE: %s\n' "$1" >&2;
	fi
}

## Prints key=value pairs, one per line
printarr() {
	declare -n __p="$1"
	for k in "${!__p[@]}"
	do printf "%s=%s\n" "$k" "${__p[$k]}"
	done
} 

## builds $parmstring by concatenating key=value pairs
catarr() {
	declare -n __p="$1"
	for k in "${!__p[@]}"
	do parmstring+=", $k=${__p[$k]}"
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


VERBOSE=0
pwd=`pwd`
declare -A parms
parms[toc]=TRUE
parms[toc_depth]=2
parms[output_dir]=\"$pwd\" 
parms[quiet]=TRUE 
parms[keep_md]=FALSE


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
			fi
			;;
	    h)
		 	echo "usage: $0 [-v] [--anyOptYouQant[=]<valueIsRequired>] [--another[=]<value>] <file.Rmd>" >&2
            echo "Default parameters are: " >&2
            printarr parms
	    	exit 2
		 	;;
        v)
			## if -v flag is present, it means TRUE
            VERBOSE=1
			## must print default parms here, before more parsing
			echo "Default parameters are:" >&2
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
echo "parmstring: $parmstring"

## No shifts inside there, so must throw away arguments
## that were processed
shift "$((OPTIND-1))"

showme "After getopts, N of args left $#"
showme "Args:  $@"

if [ ${VERBOSE} -gt 0 ]; then
	printarr parms
fi

## Retrieve the number of arguments that are left
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
			Rscript -e "library(crmda); rmd2html(\"$filename\", $parmstring)"
		else
			echo -e "Error: $filename. Extension should be \"Rmd\""
		fi
	else
 		echo -e "$filename not found"
	fi
done
exit 0



