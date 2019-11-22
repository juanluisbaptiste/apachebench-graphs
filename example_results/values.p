# output as png image
	set terminal png size 1024,768 crop

	# save file to benchmark.png
	set output "values.tsv.png"

	# graph a title
	set title "# Requests: 500 | Concurrency: 100 - coronagrival.juanbaptiste.tech"

	# nicer aspect ratio for image size
	set size 1,0.7

	# y-axis grid
	set grid y

	# x-axis label
	set xlabel "Requests"

	# y-axis label
	set ylabel "Response time \(ms\)"

  set pointsize 1

  #set Loadpath {"/home/juancho/git/apachebench-graph/results/coronagrival.juanbaptiste.tech/2019-11-21-21-57-05"}
	# plot data from server1.txt and server2.txt using column 9 with smooth sbezier lines
	#plot server1.txt using 9 smooth sbezier with lines title server1:, 	#     server2.txt using 9 smooth sbezier with lines title server2:
  plot "/home/juancho/git/apachebench-graph/results/coronagrival.juanbaptiste.tech/2019-11-21-21-57-05/values.tsv" using 9 smooth sbezier with lines title "coronagrival.juanbaptiste.tech"
