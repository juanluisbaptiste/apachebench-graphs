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
```

This script will plot [apachebench](https://httpd.apache.org/docs/2.4/programs/ab.html) results using gnuplot, and store test results
in $PWD/results/website/date/. The script will create the plot files for gnuplot
using the templates in the [templates directory](templates/). It will also save apachebench
output in a file called summary.txt


For example, this command:
```
./ab-graph.sh -u http://www.testsite.com/ -n 500 -c 100 -k
```
Will create the following results:

### Test results

* [values.csv](exmple_results/values.csv)
* [percentages.csv](exmple_results/values.csv)

### Test summary results
* summary.txt

```
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking www.testsite.com (be patient)


Server Software:        nginx/1.10.3
Server Hostname:        www.testsite.com
Server Port:            80

Document Path:          //
Document Length:        4 bytes

Concurrency Level:      100
Time taken for tests:   26.012 seconds
Complete requests:      500
Failed requests:        0
Non-2xx responses:      500
Keep-Alive requests:    0
Total transferred:      200000 bytes
HTML transferred:       2000 bytes
Requests per second:    19.22 [#/sec] (mean)
Time per request:       5202.324 [ms] (mean)
Time per request:       52.023 [ms] (mean, across all concurrent requests)
Transfer rate:          7.51 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.3      0       7
Processing:   185 4926 1699.9   4718   10431
Waiting:      180 4925 1699.8   4718   10431
Total:        185 4926 1700.2   4718   10434

Percentage of the requests served within a certain time (ms)
  50%   4718
  66%   5203
  75%   5587
  80%   5781
  90%   7518
  95%   8573
  98%   9825
  99%  10228
 100%  10434 (longest request)
```

### Plot templates

* [values.p](example_results/values.p)
* [percentages.p](example_results/percentages.p)

### Plotted results

#### Results
![GitHub Logo](/example_results/values.tsv.png)

#### Percentiles
![GitHub Logo](/example_results/percentages.csv.png)
