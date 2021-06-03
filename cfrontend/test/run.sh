#!/bin/bash

set -o errexit
set -o nounset
#set -o xtrace # trace what gets executed.

readonly red='\e[31m'
readonly green='\e[32m'
readonly lightgreen='\e[92m'
readonly reset='\033[0m'
readonly semanticdir='..'

ktest() {
    krun --directory "${semanticdir}" $1 > /dev/null
    printf "test ${1} ... ${green}ok${reset} \n" 1>&2
}

#get-tests() {
#     echo "$#"
#    if [ "$#" -eq 0 ]; then
#        echo "tti"
#        myArray=( $( ls *.c ) )
#    else
#        echo "toto"
#        myArray=( "$@" )
#    fi
#}

__main() {
    array=( $( ls *.c ) )

    printf "running ${#array[@]} tests\n"

    for i in "${array[@]}"; do
        [ -f "$i" ] || break
        ktest $i
    done
}

__main