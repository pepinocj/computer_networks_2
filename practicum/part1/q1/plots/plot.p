set xlabel "time elapsed"
set ylabel "packets received"
plot "../trace/base_throughput.tr" using 1:2 title "base case" with lines, "../trace/alt_throughput.tr" using 1:2 title "without uploader" with lines
