set xlabel "time"
set ylabel "packets per second"
plot "../trace/throughput1.tr" title "long standing FTP" with lines, "../trace/throughput2.tr" title "FTP burst traffic" with lines
