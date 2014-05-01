set xlabel "time elapsed"
set ylabel "packets received"
plot "../trace/throughput_6-1b.tr" using 1:2  with lines
