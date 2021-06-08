#!/bin/bash

set -o errexit
set -o nounset
#set -o xtrace # trace what gets executed.

readonly red='\e[31m'
readonly green='\e[32m'
readonly lightgreen='\e[92m'
readonly reset='\033[0m'
readonly semanticdir='/home/alessio/Project/osl/cfrontend'
readonly testdir='/home/alessio/Project/osl/cfrontend/test'
readonly CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"

cd $testdir

# If argument specified, only run the krun command on this files 
if [ "$#" -eq 0 ]; then
    cfiles=( $( ls *.c ) )
else
    cfiles=( "$@" )
fi

printf "running ${#cfiles[@]} tests\n"

count=1

for i in "${cfiles[@]}"; do
    [ -f "$i" ] || break

    echo -n "$count/${#cfiles[@]}  test ${i} ..."

    krun --directory "${semanticdir}" $i > /dev/null

    echo -e "\\r$count/${#cfiles[@]}  test ${i} ... ${green}ok${reset}"

    let count+=1
done

printf "test result: ${green}ok${reset}. ${#cfiles[@]} passed;\n"