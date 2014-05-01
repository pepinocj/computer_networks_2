set xlabel "time elapsed"
set ylabel "packets per second"
plot "../trace/upload_throughput.tr" using 1:2 title "upload" with lines, "../trace/download_throughput.tr" title "download" with lines
