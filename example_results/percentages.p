# output as png image
	set terminal png size 1024,768 crop

	# save file to benchmark.png
	set output "percentages.csv.png"

	# graph a title
	set title "# Requests: 500 | Concurrency: 100 - coronagrival.juanbaptiste.tech"

	# nicer aspect ratio for image size
	set size 1,0.7

	# y-axis grid
	set grid y

	# x-axis label
	set xlabel "Percentile of Users"

	# y-axis label
	set ylabel "Response time \(ms\)"

  set pointsize 1

	set datafile separator ","

  plot "/home/juancho/git/apachebench-graph/results/coronagrival.juanbaptiste.tech/2019-11-21-21-57-05/percentages.csv.fixed"  with lines title "coronagrival.juanbaptiste.tech"
