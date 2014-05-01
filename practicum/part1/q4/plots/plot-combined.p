set xlabel "time"
set ylabel "packets per second"
plot "../trace/ul_throughput.tr" using 1:2 title "upload - limited bandwidth" with lines, "../../q2/trace/upload_throughput.tr" using 1:2 title "upload - standard bandwidth" with lines, "../trace/dl_throughput.tr" using 1:2 title "download - limited bandwidth" with lines, "../../q2/trace/download_throughput.tr" using 1:2 title "download - standard bandwidth" with lines
