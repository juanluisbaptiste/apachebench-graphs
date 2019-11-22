#!/bin/bash


AB_BIN=/usr/bin/ab
GNUPLOT_BIN=/usr/bin/gnuplot
VERSION=0.1
DEFAULT_CONCURRENCY=1
DEFAULT_NUM_REQUESTS=1


usage()
{
cat << EOF
Wrapper script for Apache Bench that also plots the results.

Usage: $0 OPTIONS

OPTIONS:
-c    Concurrent connections
-k    Enable keepalive
-E    Extra parameters
-n    Number of requests
-u    Url to test
-h    Print help.
-V    Debug mode.

EOF
}

function extract_hostname() {
  local url=$1

  echo "${url}" | awk -F/ '{print $3}'
}

function render_template() {
  template_file=${1}
  result_file=${2}

  eval "echo \"$(cat ${template_file})\"" > "${result_file}"

  echo ${result_file}

}

function render_template_percentages() {
  rendered_template="${RESULTS_PATH}/percentages.p"
  echo -e "$(render_template  ${CSV_TEMPLATE_FILE} "${rendered_template}")"
}

function render_template_values() {
  rendered_template="${RESULTS_PATH}/values.p"
  echo -e "$(render_template  ${PLOT_TEMPLATE_FILE} "${rendered_template}")"
}

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "Ctrl C pressed, removing partial test results..."
        rm -fr ${RESULTS_PATH}
        exit 1
}


while getopts c:kE:n:u:hV option
do
  case "${option}"
  in
    V) set -x
       ;;

    c) CONCURRENCY="${OPTARG}"
       ;;
    k) KEEPALIVE=" -k "
       ;;
    E) EXTRA_ARGS="${OPTARG}"
       ;;
    n) NUM_REQUESTS="${OPTARG}"
       ;;
    u) URL="${OPTARG}"
       ;;
    h) usage
       exit
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

# Prepare ab parameters
HOSTNAME="$(extract_hostname ${URL})"
TEST_DATE="$(date +%Y-%m-%d-%H-%M-%S)"
RESULTS_PATH="${PWD}/results/${HOSTNAME}/${TEST_DATE}"
TEMPLATES_PATH="${PWD}/templates/"
CSV_RESULTS_FILE="${RESULTS_PATH}/percentages.csv"
PLOT_FILE="${RESULTS_PATH}/values.tsv"
CSV_TEMPLATE_FILE="${TEMPLATES_PATH}/template_percentages.tpl"
PLOT_TEMPLATE_FILE="${TEMPLATES_PATH}/template_values.tpl"
AB_OUTPUT_FILE="${RESULTS_PATH}/summary.txt"

# Create results dir
mkdir -p ${RESULTS_PATH}

echo -e "${0} - version ${VERSION}\n"


if [ "${CONCURRENCY}" == "" ]; then
  echo "No concurrency set, using default value of ${DEFAULT_CONCURRENCY} simultanious clients"
  CONCURRENCY=${DEFAULT_CONCURRENCY}
fi

if [ "${NUM_REQUESTS}" == "" ]; then
  echo "No number of requests set, using default value of ${DEFAULT_NUM_REQUESTS} requests"
  NUM_REQUESTS=${DEFAULT_NUM_REQUESTS}
fi

# Run test
AB_COMMAND="${AB_BIN} ${KEEPALIVE} -c ${CONCURRENCY} -n ${NUM_REQUESTS} -e ${CSV_RESULTS_FILE} -g ${PLOT_FILE} ${EXTRA_ARGS} ${URL}/ "
echo -e "\n${AB_COMMAND}\n"

out="$(${AB_COMMAND})"

if [ $? -gt 0 ]; then
  echo -e "There was an error running the test:\n"
  echo -e ${out}
  exit 1
fi

# Store test summary results to summary.txt
echo -e "${out}" > ${AB_OUTPUT_FILE}
echo -e "\n${out}\n\n"

##### Plot results
# Render values template
cd ${RESULTS_PATH} || exit
echo -e "Plotting values results..."

# Define plot lines
PLOT_LINES="\"${PLOT_FILE}\" using 9 smooth sbezier with lines title \"${HOSTNAME}\""
IMAGE_FILE="$(basename ${PLOT_FILE})"
rendered_values_template=$(render_template_values)

# Plot results
GNUPLOT_COMMAND="${GNUPLOT_BIN} ${rendered_values_template}"
echo -e "\n${GNUPLOT_COMMAND}\n"
${GNUPLOT_COMMAND}
echo -e "Done."

# Render percentages template
echo -e "Plotting percentages results..."
# Remove header line
sed 1d ${CSV_RESULTS_FILE} > ${CSV_RESULTS_FILE}.fixed
PLOT_LINES="\"${CSV_RESULTS_FILE}.fixed\"  with lines title \"${HOSTNAME}\""
IMAGE_FILE="$(basename ${CSV_RESULTS_FILE})"
rendered_percentages_template=$(render_template_percentages)

# Plot results
GNUPLOT_COMMAND="${GNUPLOT_BIN} ${rendered_percentages_template}"
echo -e "\n${GNUPLOT_COMMAND}\n"
${GNUPLOT_COMMAND}
echo -e "Done."

cd .. || exit
