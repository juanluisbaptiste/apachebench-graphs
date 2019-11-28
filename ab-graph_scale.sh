#!/bin/bash

START_AT=10
END_AT=25
STEP=5
NUM_REQUESTS=500
SLEEP=120

usage()
{
cat << EOF
Helper script for ab-graph that can run multple configurable runs in one go.

Usage: $0 OPTIONS

OPTIONS:
-c    Start concurrent connections at  (default: 5)
-e    Stop concurrent connections at  (defalt: 25)
-s    Concurrent connections increment step (default: 5)
-n    Number of requests      (default: 500)
-u    Url to test             (mandatory)
-w    Wait time between tests in seconds.
-h    Print help.
-V    Debug mode.

This script will do multple runs of ab-graph incrementing the concurrent connections
until al limit is reached.

EOF
}

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "Ctrl C pressed, removing partial test results..."
        rm -fr ${RESULTS_PATH}
        exit 1
}


while getopts c:e:s:n:u:w:hV option
do
  case "${option}"
  in
    c) START_AT="${OPTARG}"
       ;;
    e) END_AT="${OPTARG}"
       ;;
    s) STEP="${OPTARG}"
       ;;
    n) NUM_REQUESTS="${OPTARG}"
       ;;
    u) URL="${OPTARG}"
       ;;
    u) SLEEP="${OPTARG}"
       ;;
    h) usage
       exit
       ;;
    V) set -x
       ;;
    ?) usage
       exit
       ;;
  esac
done

#Parameter validation
if [ $# -lt 1 ] || [ "${URL}" == "" ]; then
  usage
  exit 1
fi


n=${START_AT}
while [[ ${n} -le ${END_AT} ]]; do
  echo -e "Running test...\n"
  echo -e "Current concurrency: ${n}/${END_AT}"
  ./ab-graph.sh -u http://coronagrival.juanbaptiste.tech -k -n ${NUM_REQUESTS} -c ${n}
  echo -e "Test done, waiting ${SLEEP} seconds before starting next test...\n"
  sleep ${SLEEP}
  n=$(( ${n} + ${STEP} ))
done

echo -e "Done.\n"
