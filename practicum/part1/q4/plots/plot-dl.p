set xlabel "time"
set ylabel "packets per second"
plot "../trace/dl_throughput.tr" using 1:2 title "limited bandwidth" with lines, "../../q2/trace/download_throughput.tr" using 1:2 title "standard bandwidth" with lines
