# apachebench-graph

Helper script for apachebench to automate the plotting of test results.

## Requirements

* apachebench
* bash
* gnuplot
* sed

## Usage

The script has the following options:

```
Usage: $0 OPTIONS

OPTIONS:
-c    Concurrent connections  (default: 1)
-k    Enable keepalive        (defalt: no)
-E    Extra parameters
-n    Number of requests      (default: 1)
-u    Url to test             (mandatory)
-h    Print help.
-V    Debug mode.

This script will plot apachebench results using gnuplot, and store test results in $PWD/results/website/date/. The script will create the plot files for gnuplot using the templates in the templates directory. It will also save apachebench output in a file called summary.txt
```
