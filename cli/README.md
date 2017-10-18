## Paul Johnson
## 20171013

Files

cli-5.sh: working version of named parameter parsing, deals with user
omission of values.

cli-6.sh: imports all -- arguments, but they need not be named in
the program. What dangers await?

cli-1 -- cli-4.sh: test files copied from web examples, mostly
in this thread:

https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options

But I should have studied this one harder, before:

https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash


I want a script that allows arguments. I don't want it to
be restricted to Linux, at least should work on Mac OSX. I want
it to accept POSIX style arguments, -t, -t 1, and GNU
style arguments -t1, --toc=1. 

Conclusions:

1. cannot rely on the "new extended" getopt from util-linux. It 
is not available everywhere, and there's no dependable way to
check for its availability.

That version of getopt is the one referred to as "GNU getopt" 
although it is not actually a GNU project.

As pointed out by @Urban Vagabond in that stackoverflow
thread, the role of getopt is widely misundertood. Its purpose
is to allow messy user commandlines, to allow people to do

1 -xyz rather than the POSIX standard "-x -y -z" 
or 
2 -x1 -ytrue rather than the POSIX "-x 1 -y true"
or
3 --x=1 --y=true rather than the POSIX (-x 1 -y true)
or
4 arguments mixed in with options, as in

./myscript -x 1 positional_argument -y true

So, getopt is just filtering the command line to turn
user input into the POSIX standard.


2. the traditional getopt is no good, nobody says we should
use that


3. could make strict POSIX compliant argument parser, 
at the price of forcing users to type CL arguments
in a particular style.  Only "-x -p -value1 -q value2".

POSIX standard does not allow
A. "--name3=value3" 
B. "--name4 value"
C. -xp to combine -x -p.
D. -x4 to represent "-x 4"

So I don't care much about POSIX standard for arguments anyway


4. getopts is a POSIX standard, meaning it is available in many shells. 
http://pubs.opengroup.org/onlinepubs/009695399/utilities/getopts.html

Hence we can rely on it. It is certainly available in BASH. 
Sometimes referred to as "BASH getopts." It is generally available.

What does it do? It simply parses the command line so if user 
runs "-xyz" it translates to "-x -y -z"

5. Hence, the choice is "getopts" or a shell script that
parses the argument "manually", without benefit of getopts.

6. Examples of manual shell argument parsing that accept either
"--name1 arg1" or "--name1=arg1".

A BASH wiki The Manual Loop:

http://mywiki.wooledge.org/BashFAQ/035

Note: there is a very special feature in that example--it
checks if the argument is missing, and deals with that.

   1 #!/bin/sh
   2 # POSIX
   3 
   4 die() {
   5     printf '%s\n' "$1" >&2
   6     exit 1
   7 }
   8 
   9 # Initialize all the option variables.
  10 # This ensures we are not contaminated by variables from the environment.
  11 file=
  12 verbose=0
  13 
  14 while :; do
  15     case $1 in
  16         -h|-\?|--help)
  17             show_help    # Display a usage synopsis.
  18             exit
  19             ;;
  20         -f|--file)       # Takes an option argument; ensure it has been specified.
  21             if [ "$2" ]; then
  22                 file=$2
  23                 shift
  24             else
  25                 die 'ERROR: "--file" requires a non-empty option argument.'
  26             fi
  27             ;;
  28         --file=?*)
  29             file=${1#*=} # Delete everything up to "=" and assign the remainder.
  30             ;;
  31         --file=)         # Handle the case of an empty --file=
  32             die 'ERROR: "--file" requires a non-empty option argument.'
  33             ;;
  34         -v|--verbose)
  35             verbose=$((verbose + 1))  # Each -v adds 1 to verbosity.
  36             ;;
  37         --)              # End of all options.
  38             shift
  39             break
  40             ;;
  41         -?*)
  42             printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
  43             ;;
  44         *)               # Default case: No more options, so break out of the loop.
  45             break
  46     esac
  47 
  48     shift
  49 done
  50 
  51 # if --file was provided, open it for writing, else duplicate stdout
  52 if [ "$file" ]; then
  53     exec 3> "$file"
  54 else
  55     exec 3>&1
  56 fi
  57 
  58 # Rest of the program here.
  59 # If there are input files (for example) that follow the options, they
  60 # will remain in the "$@" positional parameters.
  61 




Similar OP answer to his question
https://stackoverflow.com/questions/18414054/bash-getopts-reading-optarg-for-optional-flags

I *think* this does not allow "--banana=7" but does allow "--banana 7".

  if [[ "$1" =~ ^((-{1,2})([Hh]$|[Hh][Ee][Ll][Pp])|)$ ]]; then
    print_usage; exit 1
  else
    while [[ $# -gt 0 ]]; do
      opt="$1"
      shift;
      current_arg="$1"
      if [[ "$current_arg" =~ ^-{1,2}.* ]]; then
        echo "WARNING: You may have left an argument blank. Double check your command." 
      fi
      case "$opt" in
        "-a"|"--apple"      ) APPLE="$1"; shift;;
        "-b"|"--banana"     ) BANANA="$1"; shift;;
        "-c"|"--cherry"     ) CHERRY="$1"; shift;;
        "-d"|"--dfruit"     ) DFRUIT="$1"; shift;;
        "-e"|"--eggplant"   ) EGGPLANT="$1"; shift;;
        "-f"|"--fig"        ) FIG="$1"; shift;;
        *                   ) echo "ERROR: Invalid option: \""$opt"\"" >&2
                              exit 1;;
      esac
    done
  fi

  if [[ "$APPLE" == "" || "$BANANA" == "" ]]; then
    echo "ERROR: Options -a and -b require arguments." >&2
    exit 1
  fi


Similar manual method, does not use getopts
https://stackoverflow.com/questions/14062895/bash-argument-case-for-args-in/14063511#14063511

A manual method also in
https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options

TEMP=`getopt -o vdm: --long verbose,debug,memory:,debugfile:,minheap:,maxheap: \
             -n 'javawrap' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

VERBOSE=false
DEBUG=false
MEMORY=
DEBUGFILE=
JAVA_MISC_OPT=
while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -d | --debug ) DEBUG=true; shift ;;
    -m | --memory ) MEMORY="$2"; shift 2 ;;
    --debugfile ) DEBUGFILE="$2"; shift 2 ;;
    --minheap )
      JAVA_MISC_OPT="$JAVA_MISC_OPT -XX:MinHeapFreeRatio=$2"; shift 2 ;;
    --maxheap )
      JAVA_MISC_OPT="$JAVA_MISC_OPT -XX:MaxHeapFreeRatio=$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done




Similar method using getopts, but blended with the manual
method for options "--name=", from
https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options

optspec=":hv-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                loglevel)
                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                    ;;
                loglevel=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
                    echo "Parsing option: '--${opt}', value: '${val}'" >&2
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        h)
            echo "usage: $0 [-v] [--loglevel[=]<value>]" >&2
            exit 2
            ;;
        v)
            echo "Parsing option: '-${optchar}'" >&2
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done







7. MW points out that user error that omits argument causes
error that next argument becomes value:

./cli-4.sh --arg1= --arg2=4

the value of art1 ends up as --arg2=4 in some examples.

That problem is solved by argument checking in the BASH wiki
example







	
