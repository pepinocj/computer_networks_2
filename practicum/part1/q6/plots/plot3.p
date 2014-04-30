set xlabel "time elapsed"
set ylabel "packets received"
plot "../trace/throughput_7.tr" using 1:2  with lines
