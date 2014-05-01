set xlabel "time elapsed"
set ylabel "packets per second"
plot "../trace/base_throughput.tr" using 1:2 title "with uploader" with lines, "../trace/alt_throughput.tr" using 1:2 title "without uploader" with lines
