set xlabel "time elapsed"
set ylabel "packets received"
plot "../trace/throughput.tr" using 1:2  with lines
