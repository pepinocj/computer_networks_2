set xlabel "time elapsed"
set ylabel "packets received"
plot "base_cumulative_packets.tr" using 2:1 title "base case" with lines
