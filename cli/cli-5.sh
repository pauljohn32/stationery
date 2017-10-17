#/usr/bin/env bash

## Paul Johnson
## 20171016
##

## I'm grafting together 2 approaches to command line arguments.

## 1. make getopts tolerate long arguments by declaring "-"
##  then using manual "case" parsing on the
## matches.
## In
## https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options
## there is an example, showing long arguments by using "-" as
## the first character of a value being parsed.
## Look for answer by @Arvid Requate

## A shortcoming of that approach is that it does not protect against a user
## error that omits the argument. So user error like "./cli-5.sh --loglevel --toc=TRUE"
## causes an error, it thinks "--toc" is the value for loglevel.

## 2. Manual argument checking.
## Example in the Bash FAQ shows how to check arguments manually, to see
## if no value is provided and die if that happens.
## http://mwiki.wooledge.org/BashFAQ/035
##

## Why does that work? "-loglevel=5" becomes "loglevel=5" and then we split that
## string at the equal sign, and treat fist piece as option name and
## second piece as value.
# In code below, see how I call whole thing OPTARG, then 
# opt1=${OPTARG%=*} and value1=${OPTARG#*=}
# See: https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
# ${var#*SubStr}  # will drop begin of string upto first occur of `SubStr`
# ${var%SubStr*}  # will drop part of string from last occur of `SubStr` to the end
# See also: http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_06_02

# What I don't understand yet: 
# In the "using-getopts" example, I find this usage that retrieves a value after a space
# but i do not understand it.
# val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
# this works, but I don't understand it!


die() {
	printf '%s\n' "$1" >&2
	exit 1
}

printparse(){
	if [ ${VERBOSE} -gt 0 ]; then
		printf 'Parse: --%s%s%s\n' "$1" "$2" "$3" >&2;
	fi
}

showme(){
	if [ ${VERBOSE} -gt 0 ]; then
		printf 'VERBOSE: %s\n' "$1" >&2;
	fi
}


VERBOSE=0
loglevel=0
toc="TRUE"

optspec=":vhl:t:-:"
while getopts "$optspec" OPTCHAR; do

	showme "OPTARG:  ${OPTARG[*]}"
	showme "OPTIND:  ${OPTIND[*]}"
    case "${OPTCHAR}" in
        -)
            case "${OPTARG}" in
				loglevel) #argument has no equal sign
					opt=${OPTARG}
					val="${!OPTIND}"
					## check value exists in ${!OPTIND}
					echo "OPTIND is {$OPTIND} {!OPTIND} is _${!OPTIND}_"
					if [[ "$val" == -* ]]; then
						die "ERROR: $opt value must be supplied"
					fi
					if [ -n "${!OPTIND}" ]; then
							## OPTIND=$(( $OPTIND + 1 )) # CAUTION! no effect?
						printparse ${OPTARG} " " ${val}
						loglevel="${val}"
						shift
					else
						die "ERROR: $opt value must be supplied"
				    fi
				    ;;
                loglevel=*) #argument has equal sign
					opt=${OPTARG%=*}
					val=${OPTARG#*=}
					if [ "${OPTARG#*=}" ]; then
						printparse ${opt} "=" ${val}
						loglevel="${val}"
						## shift CAUTION don't shift this, fails othewise
					else
						die "ERROR: $opt value must be supplied"
					fi
                    ;;
				toc) #argument has no equal sign
					opt=${OPTARG}
					showme "OPTIND is {$OPTIND} {!OPTIND} is ${!OPTIND}"
					val="${!OPTIND}"
					if [ -n "$val" ]; then
						## OPTIND=$(( $OPTIND + 1 )) #??
						printparse ${opt} " " ${val}
						toc="${val}"
						shift
					else
						die "ERROR: $opt value must be supplied"
				    fi
				    ;;
				toc=*) #argument has equal sign
                    opt=${OPTARG%=*}
					val=${OPTARG#*=}
					if [ "${OPTARG#*=}" ]; then
						toc=${val}
						printparse $opt " -> " $toc
						##shift ## NO! dont shift this
					else
                		die "ERROR: value for $opt undefined"
					fi
                    ;;

				help)
					echo "usage: $0 [-v] [--loglevel[=]<value>] [--toc[=]<TRUE,FALSE>]" >&2
					exit 2
					;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        h|-\?|--help)
			## must rewrite this for all of the arguments
            echo "usage: $0 [-v] [--loglevel[=]<value>] [--toc[=]<TRUE,FALSE>]" >&2
            exit 2
            ;;
		l)
			loglevel=${OPTARG}
			;;
		t)
			toc=${OPTARG}
			;;
		v)
            VERBOSE=1
			;;

        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done


## Test that

## In newest version, flag -v means VERBOSE printout
## ./cli-5.sh  -v --loglevel=44 --toc  TRUE
## ./cli-5.sh  -v --loglevel=44 --toc  TRUE
## ./cli-5.sh --loglevel 7
## ./cli-5.sh --loglevel=8
## ./cli-5.sh -l9

## ./cli-5.sh  --toc FALSE --loglevel=77
## ./cli-5.sh  --toc=FALSE --loglevel=77
## ./cli-5.sh  --toc --loglevel=77

## ./cli-5.sh   -l99 -t yyy
## ./cli-5.sh   -l 99 -t yyy


echo "
After Parsing values
"
echo "loglevel  $loglevel" 
echo "toc  $toc"
