# output as png image
	set terminal png size 1024,768 crop

	# save file to benchmark.png
	set output "merged_values.png"

	# graph a title
	set title "Merged Test Results"

	# nicer aspect ratio for image size
	set size 1,0.7

	# y-axis grid
	set grid y

	# x-axis label
	set xlabel "Requests"

	# y-axis label
	set ylabel "Response time \(ms\)"

  set pointsize 1

  plot "/home/juancho/git/apachebench-graph/results/www.testsite.com/2020-04-22-23-32-26/values.tsv" using 9 smooth sbezier with lines title "www.testsite.com - 2020-04-22-23-32-26","/home/juancho/git/apachebench-graph/results/www.testsite.com/2020-04-22-23-34-50/values.tsv" using 9 smooth sbezier with lines title "www.testsite.com - 2020-04-22-23-34-50"
