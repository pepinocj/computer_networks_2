set xlabel "time"
set ylabel "packets per second"
plot "../trace/ul_throughput.tr" using 1:2 title "limited bandwidth" with lines, "../../q2/trace/upload_throughput.tr" using 1:2 title "standard bandwidth" with lines
