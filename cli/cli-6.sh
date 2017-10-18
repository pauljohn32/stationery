#/usr/bin/env bash


## Paul Johnson
## 20171018
##

## A new strategy on argument parsing. Any argument that begins with
## -- will be accepted and parsed. It is NOT necessary to name the
## acceptable arguments in this script.

## Creates 2 arrays, optary and valary. One for option names and one
## for values.  Accepts both "--opt=value" and "--opt value"

## Standard parsing of POSIX style argument still happens,
## only interesting variation here is the handling of -- arguments.

## Why? In other approaches,
## https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options
## or
## http://mwiki.wooledge.org/BashFAQ/035
##
## it is too tedious to copy/paste the stanzas for each parameter, for
## each style of argument. Now adopt simpler idea that every "--"
## argument has to be parsed and the "opt" and "value" elements
## derived.

die() {
	printf '%s\n' "$1" >&2
	exit 1
}


printparse(){
	if [ ${VERBOSE} -gt 0 ]; then
		printf 'Parse: %s%s%s\n' "$1" "$2" "$3" >&2;
	fi
}

showme(){
	if [ ${VERBOSE} -gt 0 ]; then
		printf 'VERBOSE: %s\n' "$1" >&2;
	fi
}


VERBOSE=1

## index for imported values in optary and valary arrays
idx=0
## Need v first so VERBOSE is set early
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
				printparse "--${opt}" "=" "\"${val}\""
			   	if [[ -z $val ]]; then
					die "ERROR: $opt is empty."
				fi
				optary[${idx}]=${opt}
				valary[${idx}]=${val}
				idx=$(($idx + 1))
			else
	            showme "There is no equal sign in ${OPTARG}"
				opt=${OPTARG}
				val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
				printparse "--${OPTARG}" " " "\"${val}\""
		  		if [[ "$val" == -* ]]; then
					die "ERROR: $opt value must be supplied"
				fi
				optary[${idx}]=${opt}
				valary[${idx}]=${val}
				idx=$(($idx + 1))
			fi
			;;
	    h)
		 	echo "usage: $0 [-v] [--anyOptYouQant[=]<valueIsRequired>] [--another[=]<value>]" >&2
	    	exit 2
		 	;;
        v)
			## if -v flag is present, it means TRUE
             VERBOSE=1
             ;;
        *)
             if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                 die "Undefined argument: '-${OPTARG}'"
             fi
             ;;
	esac
done


## Test that
## ./cli-6.sh -v --friend=paul --toc=TRUE --school=Kansas
## ./cli-6.sh --friend=paul --toc=TRUE --school=Kansas
## ./cli-6.sh -k --friend=paul
##
## ./cli-6.sh -v --friend=paul --toc TRUE --school Kansas

echo "
After Parsing values, ordinary getopts POSIX opts
"
echo "VERBOSE  $VERBOSE" 

echo 'Arrays of opts and values'
echo "optary:  ${optary[*]}"
echo "valary:  ${valary[*]}"

