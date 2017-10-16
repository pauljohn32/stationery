#/usr/bin/env bash

## https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options

## This works, allegedly because of a flaw in POSIX argument processing.
## 

## Inserting die and check for value from mwiki.wooledge.org/BashFAQ/035
##

# Deal with arguments formatted as  --opt1=value1 by string splitting
# Call whole thing OPTARG, then 
# opt1=${OPTARG%=*} and value1=${OPTARG#*=}
# See: https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
# ${var#*SubStr}  # will drop begin of string upto first occur of `SubStr`
# ${var##*SubStr} # will drop begin of string upto last occur of `SubStr`
# ${var%SubStr*}  # will drop part of string from last occur of `SubStr` to the end
# ${var%%SubStr*} # will drop part of string from first occur of `SubStr` to the end

# More on Parameter Expansion
# http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_06_02

# In the "using-getopts" page, I find this usage that retrieves a value after a space
# but i do not understand it.
# val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))

die() {
	printf '%s\n' "$1" >&2
	exit 1
}

printparse(){
	printf 'Parsing option: --%s%s%s\n' "$1" "$2" "$3" >&2;
}

loglevel=0
toc="TRUE"

optspec=":lthv-:"
while getopts "$optspec" OPTCHAR; do
    case "${OPTCHAR}" in
        -)
            case "${OPTARG}" in
				loglevel)
					## retrieve next parameter , if exists
					echo "OPTIND is {$OPTIND} {!OPTIND} is ${!OPTIND}"
					if [ "${!OPTIND}" ]; then
						val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
						printparse ${OPTARG} " " ${val}
						loglevel="${val}"
						shift
					else
						die "ERROR: $opt value must be supplied"
				    fi
				    ;;
                loglevel=?*)
					opt=${OPTARG%=}
					if [ "${OPTARG#*=}" ]; then
						val=${OPTARG#*=}
						printparse ${opt} "=" ${val}
						loglevel="${val}"
						shift
					else
						die "ERROR: $opt value must be supplied"
					fi
                    ;;
				toc)
					echo "OPTIND is {$OPTIND} {!OPTIND} is ${!OPTIND}"
					if [ "$1" ]; then
					    opt=${OPTARG}
						val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
						printparse ${OPTARG} " " ${val}
						## Kill if value begins with dash
						if [[ "$val" == -* ]]; then
						   die "ERROR: $opt value must be supplied"
						fi
						toc="${val}"
						shift
					else
						die "ERROR: $opt value must be supplied"
				    fi
				    ;;
				toc=?*)
                    opt=${OPTARG%=}
					if [ "${OPTARG#*=}" ]; then
						toc=${OPTARG#*=}
						printparse $opt " -> " $toc
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
        v)
            echo "Parsing option: '-${OPTCHAR}'" >&2
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done


## Test that
## ./cli-5.sh --loglevel 7
## ./cli-5.sh --loglevel=8
## ./cli-5.sh -l9

echo "After Parsing values"
echo "loglevel  $loglevel" 
echo "toc  $toc"
