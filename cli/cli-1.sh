#!/bin/sh

##https://unix.stackexchange.com/questions/129391/passing-named-arguments-to-shell-scripts

while [ $# -gt 0 ]; do
    case "$1" in
        -p|--p_out=*)
			p_out="${1#*=}"
			;;
		-q|--arg_1=*)
			arg_1="${1#*=}"
			;;
		-r|--arg_2=*)
			arg_2="${1#*=}"
			;;
		*)
			printf "***************************\n"
			printf "* Error: Invalid argument.*\n"
			printf "***************************\n"
			exit 1
	esac
	shift
done


echo $p_out

echo $arg_1

echo $arg_2

