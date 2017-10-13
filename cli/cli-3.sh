#!/bin/sh

## This handles CL arguments without getopt or getopts
## from anywhere!

## Somewhat restrictive, but allows either -v or --verbose as flag,
## or -m55 or --memory 55. Note it does not allow equal sign!

## OK:
## ./cli-3.sh -m 45
## ./cli-3.sh --memory 55
## FAIL:
## ./cli-3.sh --memory=55

## Take the getopt based script here
## https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options
##
## but cut out the getopt based part, as author claims
## is possible. This is proposed by 


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

echo $VERBOSE
echo $DEBUG
echo $MEMORY
echo $DEBUGFILE
echo $JAVA_MISC_OPT


## Example usages
## ./cli-3.sh --memory 55 --maxheap 44
## ./cli-3.sh --memory 55 --maxheap 44 --verbose
