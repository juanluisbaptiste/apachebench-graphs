# output as png image
	set terminal png size 1024,768 crop

	# save file to benchmark.png
	set output "merged_percentages.png"

	# graph a title
	set title "Merged Test Results"

	# nicer aspect ratio for image size
	set size 1,0.7

	# y-axis grid
	set grid y

	# x-axis label
	set xlabel "Percentiles"

	# y-axis label
	set ylabel "Response time \(ms\)"

  set pointsize 1

	set datafile separator ","

  plot "/home/juancho/git/apachebench-graph/results/grival2.ddbdev.xyz/2020-04-22-23-32-26/percentages.csv.fixed" with lines title "grival2.ddbdev.xyz - 2020-04-22-23-32-26","/home/juancho/git/apachebench-graph/results/grival.ddbdev.xyz/2020-04-22-23-34-50/percentages.csv.fixed" with lines title "grival.ddbdev.xyz - 2020-04-22-23-34-50"
