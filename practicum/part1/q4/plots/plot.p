set xlabel "time elapsed"
set ylabel "packets received"
plot "../trace/throughput.tr" using 1:2 title "limited bandwidth" with lines, "../../q1/trace/base_throughput.tr" using 1:2 title "base case" with lines
