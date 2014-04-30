set xlabel "time elapsed"
set ylabel "packets received"
plot "alternative_cumulative_packets.tr" using 2:1 title "without uploader" with lines
